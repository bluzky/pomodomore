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

    /// Toggle tick sound on/off
    func toggleTickSound() {
        isTickSoundEnabled.toggle()

        // Update settings
        settingsManager.settings.sound.soundButtonEnabled = isTickSoundEnabled

        // If timer is running, start/stop tick sound accordingly
        if currentState == .running {
            if isTickSoundEnabled {
                let tickSound = settingsManager.settings.sound.tickSound
                if tickSound != "None" {
                    soundManager.startTickLoop(soundName: tickSound)
                }
            } else {
                soundManager.stopTickLoop()
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
        // Ambient sound only for Pomodoro sessions
        if currentSessionType == .pomodoro && ambientSound != .none {
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

        // Create completed session record with selected tag
        let completedSession = Session(
            sessionType: currentSessionType,
            sessionNumber: completedSessions + 1,
            selectedTag: selectedTag
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

        // Auto-transition to next session
        transitionToNextSession()
    }

    /// Transition to the next session type based on Pomodoro cycle logic
    private func transitionToNextSession() {
        let nextSessionType: SessionType

        switch currentSessionType {
        case .pomodoro:
            // After Pomodoro, take a break
            nextSessionType = completedSessions == 4 ? .longBreak : .shortBreak
        case .shortBreak:
            // After short break, back to Pomodoro
            nextSessionType = .pomodoro
            selectedTag = lastSelectedTag // Restore last selected tag as default
        case .longBreak:
            // After long break, reset counter and back to Pomodoro
            completedSessions = 0
            nextSessionType = .pomodoro
            selectedTag = lastSelectedTag // Restore last selected tag as default
            print("🔄 Cycle reset! Starting new Pomodoro cycle")
        }

        // Update session type and reset timer
        currentSessionType = nextSessionType
        timeRemaining = nextSessionType.duration
        currentState = .idle

        print("🔄 Auto-transitioned to: \(nextSessionType.displayName.isEmpty ? "Pomodoro" : nextSessionType.displayName)")
    }
}
