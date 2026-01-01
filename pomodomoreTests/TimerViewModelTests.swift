//
//  TimerViewModelTests.swift
//  pomodomoreTests
//
//  Created on 01/06/25.
//

import Testing
@testable import pomodomore

@MainActor
struct TimerViewModelTests {

    // MARK: - Initialization Tests

    @Test func initializesWithPomodoroSessionType() {
        let viewModel = TimerViewModel()
        #expect(viewModel.currentSessionType == .pomodoro, "Should initialize with Pomodoro session type")
    }

    @Test func initializesWithPomodoroDuration() {
        let viewModel = TimerViewModel()
        #expect(viewModel.timeRemaining == 1500, "Should initialize with Pomodoro duration (25 min = 1500s)")
    }

    @Test func initializesInIdleState() {
        let viewModel = TimerViewModel()
        #expect(viewModel.currentState == .idle, "Should initialize in idle state")
    }

    // MARK: - Session Type Duration Tests

    @Test func pomodoroSessionHasCorrectDuration() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .pomodoro
        viewModel.reset()
        #expect(viewModel.timeRemaining == 1500, "Pomodoro session should reset to 1500 seconds")
    }

    @Test func shortBreakSessionHasCorrectDuration() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .shortBreak
        viewModel.reset()
        #expect(viewModel.timeRemaining == 300, "Short Break session should reset to 300 seconds")
    }

    @Test func longBreakSessionHasCorrectDuration() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .longBreak
        viewModel.reset()
        #expect(viewModel.timeRemaining == 900, "Long Break session should reset to 900 seconds")
    }

    // MARK: - Reset Tests

    @Test func resetRestoresSessionTypeDuration() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .shortBreak
        viewModel.timeRemaining = 100 // Simulate countdown
        viewModel.reset()
        #expect(viewModel.timeRemaining == 300, "Reset should restore Short Break duration")
        #expect(viewModel.currentState == .idle, "Reset should set state to idle")
    }

    @Test func resetWorksAfterSessionTypeChange() {
        let viewModel = TimerViewModel()

        // Start with Pomodoro
        #expect(viewModel.timeRemaining == 1500)

        // Change to Long Break
        viewModel.currentSessionType = .longBreak
        viewModel.reset()
        #expect(viewModel.timeRemaining == 900, "Should use Long Break duration after session type change")
    }

    // MARK: - Time Formatting Tests

    @Test func timeFormattedShowsCorrectPomodoroTime() {
        let viewModel = TimerViewModel()
        #expect(viewModel.timeFormatted == "25:00", "Pomodoro should display as 25:00")
    }

    @Test func timeFormattedShowsCorrectShortBreakTime() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .shortBreak
        viewModel.reset()
        #expect(viewModel.timeFormatted == "05:00", "Short Break should display as 05:00")
    }

    @Test func timeFormattedShowsCorrectLongBreakTime() {
        let viewModel = TimerViewModel()
        viewModel.currentSessionType = .longBreak
        viewModel.reset()
        #expect(viewModel.timeFormatted == "15:00", "Long Break should display as 15:00")
    }

    // MARK: - Start/Pause/Reset Flow Tests

    @Test func startPauseResetFlowWorksWithDifferentSessionTypes() async throws {
        let viewModel = TimerViewModel()

        // Test with Short Break
        viewModel.currentSessionType = .shortBreak
        viewModel.reset()

        // Should start at 5:00
        #expect(viewModel.timeRemaining == 300)
        #expect(viewModel.currentState == .idle)

        // Start timer
        viewModel.start()
        #expect(viewModel.currentState == .running)

        // Wait for countdown
        try await Task.sleep(for: .seconds(2))
        #expect(viewModel.timeRemaining < 300, "Timer should have counted down")

        // Pause
        viewModel.pause()
        #expect(viewModel.currentState == .paused)
        let pausedTime = viewModel.timeRemaining

        // Resume
        viewModel.start()
        #expect(viewModel.currentState == .running)

        // Reset
        viewModel.reset()
        #expect(viewModel.timeRemaining == 300, "Reset should restore Short Break duration")
        #expect(viewModel.currentState == .idle)
    }

    // MARK: - Multiple Session Type Switching Tests

    @Test func switchingBetweenSessionTypesUpdatesCorrectly() {
        let viewModel = TimerViewModel()

        // Start with Pomodoro
        #expect(viewModel.currentSessionType == .pomodoro)
        #expect(viewModel.timeRemaining == 1500)

        // Switch to Short Break
        viewModel.currentSessionType = .shortBreak
        viewModel.reset()
        #expect(viewModel.timeRemaining == 300)

        // Switch to Long Break
        viewModel.currentSessionType = .longBreak
        viewModel.reset()
        #expect(viewModel.timeRemaining == 900)

        // Back to Pomodoro
        viewModel.currentSessionType = .pomodoro
        viewModel.reset()
        #expect(viewModel.timeRemaining == 1500)
    }
}
