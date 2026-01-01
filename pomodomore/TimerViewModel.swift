//
//  TimerViewModel.swift
//  pomodomore
//
//  Created on 01/02/25.
//

import Foundation
import Combine

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

    /// Time remaining in seconds
    @Published var timeRemaining: Int = 1500 // 25 minutes = 1500 seconds

    // MARK: - Private Properties

    /// Subscription to the timer publisher
    private var timerCancellable: AnyCancellable?

    // MARK: - Initialization

    init() {
        // Initialize time remaining based on default session type
        self.timeRemaining = currentSessionType.duration
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
    }

    /// Reset the timer to initial state
    func reset() {
        print("🔄 Timer reset")
        currentState = .idle
        timeRemaining = currentSessionType.duration
        timerCancellable?.cancel()
        
        // Don't reset session counter or type - just restart current session
        print("🔄 Reset to: \(currentSessionType.displayName.isEmpty ? "Pomodoro" : currentSessionType.displayName)")
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
        
        // Create completed session record
        let completedSession = Session(sessionType: currentSessionType, sessionNumber: completedSessions + 1)
        currentSession = completedSession
        
        // Update session counter if this was a Pomodoro
        if currentSessionType == .pomodoro {
            completedSessions += 1
            print("📊 Completed Pomodoro \(completedSessions)/4")
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
        case .longBreak:
            // After long break, reset counter and back to Pomodoro
            completedSessions = 0
            nextSessionType = .pomodoro
            print("🔄 Cycle reset! Starting new Pomodoro cycle")
        }
        
        // Update session type and reset timer
        currentSessionType = nextSessionType
        timeRemaining = nextSessionType.duration
        currentState = .idle
        
        print("🔄 Auto-transitioned to: \(nextSessionType.displayName.isEmpty ? "Pomodoro" : nextSessionType.displayName)")
    }
}
