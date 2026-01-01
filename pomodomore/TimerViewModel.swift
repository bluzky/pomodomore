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

    /// Time remaining in seconds
    @Published var timeRemaining: Int = 1500 // 25 minutes = 1500 seconds

    // MARK: - Private Properties

    /// Total duration of a Pomodoro session in seconds
    private let totalTime: Int = 1500 // 25 minutes

    /// Subscription to the timer publisher
    private var timerCancellable: AnyCancellable?

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
        timeRemaining = totalTime
        timerCancellable?.cancel()
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
    }
}
