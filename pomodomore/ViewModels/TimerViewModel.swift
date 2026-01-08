//
//  TimerViewModel.swift
//  pomodomore
//
//  Created on 01/02/25.
//

import Foundation
import Combine
import SwiftUI

/// View model managing Pomodoro timer state and countdown logic
@MainActor
class TimerViewModel: ObservableObject {
    // MARK: - Published Properties

    /// Current state of the timer
    @Published var currentState: TimerState = .idle

    /// Current session type (Pomodoro, Short Break, or Long Break)
    @Published var currentSessionType: SessionType = .pomodoro

    /// Number of completed Pomodoro sessions in current cycle (0-4)
    @Published var completedSessions: Int = 0

    /// Current active session (nil until first completion)
    @Published var currentSession: Session?

    /// Currently selected tag for the next Pomodoro session
    @Published var selectedTag: SessionTag = .defaultTag

    /// Last selected tag (persisted as default for next session)
    @Published var lastSelectedTag: SessionTag = .defaultTag

    /// Completion state for session completion floating view
    @Published var completionState: CompletionState = .hidden

    /// Whether tick sound is currently enabled (toggled by sound button)
    @Published var isTickSoundEnabled: Bool = true

    /// Time remaining in seconds
    @Published var timeRemaining: Int = 1500 // 25 minutes = 1500 seconds

    // MARK: - Services

    private let settingsManager = SettingsManager.shared
    private let soundManager = SoundManager.shared
    private let notificationManager = NotificationManager.shared
    private let storageManager = StorageManager.shared
    private let statisticsManager = StatisticsManager.shared

    // MARK: - Private Properties

    /// Subscription to the timer publisher
    private var timerCancellable: AnyCancellable?

    // MARK: - Initialization

    init() {
        // Initialize time remaining based on default session type
        self.timeRemaining = currentSessionType.duration

        // Load tick sound enabled state from settings
        self.isTickSoundEnabled = settingsManager.settings.sound.soundButtonEnabled

        // Request notification permission on first launch
        Task {
            await notificationManager.requestPermission()
        }
    }

    // MARK: - Sound Control

    /// Toggle all sounds on/off (tick + ambient)
    func toggleAllSounds() {
        isTickSoundEnabled.toggle()

        // Update settings
        settingsManager.settings.sound.soundButtonEnabled = isTickSoundEnabled

        // If timer is running, start/stop all sounds accordingly
        if currentState == .running {
            if isTickSoundEnabled {
                // Start tick sound
                let tickSound = settingsManager.settings.sound.tickSound
                if tickSound != "None" {
                    soundManager.startTickLoop(soundName: tickSound)
                }

                // Start ambient sound (only for Pomodoro)
                if currentSessionType == .pomodoro {
                    let ambientSound = settingsManager.settings.sound.ambientSound
                    if ambientSound != .none {
                        soundManager.startAmbient(ambientSound)
                    }
                }
            } else {
                // Stop all sounds
                soundManager.stopTickLoop()
                soundManager.stopAmbient()
            }
        }
    }

    // MARK: - Computed Properties

    /// Formatted time string in MM:SS format
    var timeFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Title for the primary action button (Start/Pause)
    var primaryActionTitle: String {
        currentState == .running ? "Pause" : "Start"
    }

    /// Color for the timer display based on current state and session type
    var timerColor: Color {
        switch (currentState, currentSessionType) {
        case (.running, .pomodoro):
            return .green
        case (.paused, .pomodoro):
            return .orange
        case (.running, .shortBreak), (.running, .longBreak):
            return .cyan
        default:
            return .primary
        }
    }

    // MARK: - Public Methods

    /// Toggle between start and pause states
    func toggle() {
        if currentState == .running {
            pause()
        } else {
            start()
        }
    }

    /// Start the timer countdown
    func start() {
        // Prevent starting if already running
        guard currentState != .running else {
            print("⚠️ Timer already running")
            return
        }

        print("▶️ Timer started")
        currentState = .running

        // Play start sound
        soundManager.playStart()

        // Start sounds
        let tickSound = settingsManager.settings.sound.tickSound
        let ambientSound = settingsManager.settings.sound.ambientSound

        // Tick sound for all session types (Pomodoro + Breaks)
        if isTickSoundEnabled && tickSound != "None" {
            soundManager.startTickLoop(soundName: tickSound)
        }
        // Ambient sound only for Pomodoro sessions (respects sound button toggle)
        if isTickSoundEnabled && currentSessionType == .pomodoro && ambientSound != .none {
            soundManager.startAmbient(ambientSound)
        }

        // Create timer that fires every second
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    /// Pause the timer countdown
    func pause() {
        // Only pause if currently running
        guard currentState == .running else {
            print("⚠️ Timer not running, cannot pause")
            return
        }

        print("⏸️ Timer paused at \(timeFormatted)")
        currentState = .paused
        timerCancellable?.cancel()

        // Stop looping sounds first, then play stop sound
        soundManager.stopLoopingSounds()
        soundManager.playStop()
    }

    /// Reset the timer to initial state
    func reset() {
        print("🔄 Timer reset")
        currentState = .idle
        timeRemaining = currentSessionType.duration
        timerCancellable?.cancel()

        // Stop looping sounds first, then play stop sound
        soundManager.stopLoopingSounds()
        soundManager.playStop()

        // Don't reset session counter or type - just restart current session
        print("🔄 Reset to: \(currentSessionType.displayName.isEmpty ? "Pomodoro" : currentSessionType.displayName)")
    }

    /// Stop the current session and return to idle Pomodoro state
    func stop() {
        print("🛑 Session stopped")
        currentState = .idle
        currentSessionType = .pomodoro
        timeRemaining = currentSessionType.duration
        timerCancellable?.cancel()

        // Stop looping sounds first, then play stop sound
        soundManager.stopLoopingSounds()
        soundManager.playStop()

        // Preserve completedSessions (cycle progress) and selectedTag (user choice)
        print("🛑 Stopped - Session counter: \(completedSessions), Tag: \(selectedTag.name)")
    }

    /// Skip the current break and return to Pomodoro
    func skipBreak() {
        print("⏭️ Break skipped")
        currentState = .idle
        currentSessionType = .pomodoro
        timeRemaining = currentSessionType.duration
        timerCancellable?.cancel()

        // Stop looping sounds
        soundManager.stopLoopingSounds()

        // Play a soft stop sound (not as loud as full stop)
        soundManager.playStop()

        // Preserve completedSessions (cycle progress) and selectedTag (user choice)
        print("⏭️ Break skipped - Back to Pomodoro. Counter: \(completedSessions)")
    }

    // MARK: - Completion View Actions

    /// Start break from completion view - break runs inside completion window
    func startBreakFromCompletion() {
        print("⏯️ Starting break from completion view")

        // Determine which break type based on completed sessions
        let nextBreakType: SessionType = completedSessions == 4 ? .longBreak : .shortBreak

        currentSessionType = nextBreakType
        timeRemaining = nextBreakType.duration
        currentState = .running
        completionState = .breakRunning(timeRemaining: timeRemaining)

        // Start timer and sounds
        startTimer()
        startSounds()
    }

    /// Skip break and start next Pomodoro immediately
    func skipBreakFromCompletion() {
        print("⏭️ Skipping break and starting next Pomodoro")

        currentSessionType = .pomodoro
        timeRemaining = currentSessionType.duration
        currentState = .running
        completionState = .hidden

        // Start timer and sounds immediately
        soundManager.playStart()
        startTimer()
        startSounds()
    }

    /// Start next Pomodoro after break (always idle, never auto-start)
    func startNextPomodoroFromCompletion() {
        print("▶️ Starting next Pomodoro from completion view")

        // Reset counter if long break just completed
        if currentSessionType == .longBreak {
            completedSessions = 0
            print("🔄 Cycle reset! Starting new Pomodoro cycle")
        }

        currentSessionType = .pomodoro
        timeRemaining = currentSessionType.duration
        currentState = .idle
        completionState = .hidden
        selectedTag = lastSelectedTag // Restore last tag
    }

    /// Cancel/dismiss completion view
    func dismissCompletionView() {
        print("❌ Dismissing completion view")
        completionState = .hidden
    }

    // MARK: - Private Methods

    /// Called every second when timer is running
    private func tick() {
        // Check if time has run out
        guard timeRemaining > 0 else {
            complete()
            return
        }

        // Decrement time by one second
        timeRemaining -= 1

        // Update completion state with new time if break is running
        if case .breakRunning(_) = completionState {
            completionState = .breakRunning(timeRemaining: timeRemaining)
        }
    }

    /// Called when timer reaches 00:00
    private func complete() {
        print("✅ Timer completed!")
        currentState = .completed
        timerCancellable?.cancel()

        // Stop all sounds on completion
        soundManager.stopAll()

        // Play completion sound from bundled resources
        let completionSound = settingsManager.settings.sound.completionSound
        soundManager.playCompletionSound(completionSound)

        // Create completed session record with selected tag and actual duration
        let completedSession = Session(
            sessionType: currentSessionType,
            sessionNumber: completedSessions + 1,
            selectedTag: selectedTag,
            duration: currentSessionType.duration
        )
        currentSession = completedSession

        // Save session to storage (only Pomodoro sessions are tracked in stats)
        if currentSessionType == .pomodoro {
            var allSessions = storageManager.loadSessions()
            allSessions.append(completedSession)
            storageManager.saveSessions(allSessions)

            // Refresh statistics to update dashboard
            statisticsManager.refresh()

            print("💾 Session saved to storage - Total sessions: \(allSessions.count)")
        }

        // Update session counter and save tag if this was a Pomodoro
        if currentSessionType == .pomodoro {
            completedSessions += 1
            lastSelectedTag = selectedTag // Save for next session default
            print("📊 Completed Pomodoro \(completedSessions)/4 - Tag: \(selectedTag.name)")

            // Send notification for Pomodoro completion
            Task {
                await notificationManager.showPomodoroComplete(
                    sessionsCompleted: completedSessions,
                    totalInSet: settingsManager.settings.pomodoro.longBreakInterval
                )
            }
        } else {
            // Send notification for break completion
            Task {
                await notificationManager.showBreakComplete()
            }
        }

        // Show completion view or auto-transition based on setting
        if settingsManager.settings.pomodoro.showCompletionView {
            // Show completion view instead of auto-transitioning
            if currentSessionType == .pomodoro {
                // Check auto-start break setting
                if settingsManager.settings.pomodoro.autoStartBreak {
                    // Auto-start break in completion view
                    let nextBreakType: SessionType = completedSessions == 4 ? .longBreak : .shortBreak
                    currentSessionType = nextBreakType
                    timeRemaining = nextBreakType.duration
                    currentState = .running
                    completionState = .breakRunning(timeRemaining: timeRemaining)

                    // Start timer and sounds
                    startTimer()
                    startSounds()
                    print("⏯️ Auto-starting \(nextBreakType.displayName) in completion view")
                } else {
                    // Wait for user to manually start break
                    completionState = .pomodoroComplete
                    print("✅ Pomodoro complete - waiting for user action")
                }
            } else {
                // Break completed
                completionState = .breakComplete
                print("✅ Break complete - waiting for user action")
            }
        } else {
            // Auto-transition to next session (original behavior)
            transitionToNextSession()
        }
    }

    /// Transition to the next session type based on Pomodoro cycle logic
    private func transitionToNextSession() {
        let nextSessionType: SessionType
        let shouldAutoStart: Bool

        switch currentSessionType {
        case .pomodoro:
            // After Pomodoro, take a break
            nextSessionType = completedSessions == 4 ? .longBreak : .shortBreak
            shouldAutoStart = settingsManager.settings.pomodoro.autoStartBreak
        case .shortBreak:
            // After short break, back to Pomodoro (never auto-start)
            nextSessionType = .pomodoro
            selectedTag = lastSelectedTag // Restore last selected tag as default
            shouldAutoStart = false
        case .longBreak:
            // After long break, reset counter and back to Pomodoro (never auto-start)
            completedSessions = 0
            nextSessionType = .pomodoro
            selectedTag = lastSelectedTag // Restore last selected tag as default
            shouldAutoStart = false
            print("🔄 Cycle reset! Starting new Pomodoro cycle")
        }

        // Update session type and reset timer
        currentSessionType = nextSessionType
        timeRemaining = nextSessionType.duration
        currentState = shouldAutoStart ? .running : .idle

        // Start timer if auto-start is enabled
        if shouldAutoStart {
            startSounds()
            startTimer()
        }

        print("🔄 Auto-transitioned to: \(nextSessionType.displayName.isEmpty ? "Pomodoro" : nextSessionType.displayName) - auto-start: \(shouldAutoStart)")
    }

    /// Start timer sounds (tick and ambient)
    private func startSounds() {
        let tickSound = settingsManager.settings.sound.tickSound
        let ambientSound = settingsManager.settings.sound.ambientSound

        if isTickSoundEnabled && tickSound != "None" {
            soundManager.startTickLoop(soundName: tickSound)
        }
        // Ambient sound only for Pomodoro sessions (respects sound button toggle)
        if isTickSoundEnabled && currentSessionType == .pomodoro && ambientSound != .none {
            soundManager.startAmbient(ambientSound)
        }
    }

    /// Start the timer publisher
    private func startTimer() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }
}
