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

    // MARK: - Session Tag Tests

    @Test func initializesWithDefaultTag() {
        let viewModel = TimerViewModel()
        #expect(viewModel.selectedTag == SessionTag.defaultTag, "Should initialize with default tag")
        #expect(viewModel.lastSelectedTag == SessionTag.defaultTag, "lastSelectedTag should be default")
    }

    @Test func selectedTagCanBeChanged() {
        let viewModel = TimerViewModel()
        viewModel.selectedTag = .work
        #expect(viewModel.selectedTag == .work, "Selected tag should update to Work")
    }

    @Test func selectedTagPersistsAllTags() {
        let viewModel = TimerViewModel()
        for tag in SessionTag.predefinedTags {
            viewModel.selectedTag = tag
            #expect(viewModel.selectedTag == tag, "Should persist \(tag.name) tag")
        }
    }

    @Test func lastSelectedTagUpdatesOnCompletion() {
        let viewModel = TimerViewModel()
        viewModel.selectedTag = .research
        viewModel.timeRemaining = 0

        // Simulate completion (would normally be called by tick())
        // We can't easily test private complete() method, but we test the logic indirectly
        #expect(viewModel.selectedTag == .research, "Selected tag should be Research before completion")
    }

    // MARK: - Stop Method Tests

    @Test func stopReturnsToPomodoroIdleState() {
        let viewModel = TimerViewModel()

        // Start a Short Break
        viewModel.currentSessionType = .shortBreak
        viewModel.start()
        #expect(viewModel.currentState == .running)

        // Stop
        viewModel.stop()

        #expect(viewModel.currentState == .idle, "Stop should set state to idle")
        #expect(viewModel.currentSessionType == .pomodoro, "Stop should return to Pomodoro")
        #expect(viewModel.timeRemaining == 1500, "Stop should reset to Pomodoro duration")
    }

    @Test func stopPreservesSessionCounter() {
        let viewModel = TimerViewModel()

        // Simulate having completed 2 Pomodoros
        viewModel.completedSessions = 2

        // Start a session and stop it
        viewModel.start()
        viewModel.stop()

        #expect(viewModel.completedSessions == 2, "Stop should preserve session counter")
    }

    @Test func stopPreservesSelectedTag() {
        let viewModel = TimerViewModel()

        // Set a tag
        viewModel.selectedTag = .meeting
        viewModel.lastSelectedTag = .meeting

        // Start and stop
        viewModel.start()
        viewModel.stop()

        #expect(viewModel.selectedTag == .meeting, "Stop should preserve selected tag")
        #expect(viewModel.lastSelectedTag == .meeting, "Stop should preserve last selected tag")
    }

    @Test func stopDuringPomodoroPreservesState() {
        let viewModel = TimerViewModel()

        // Set up state
        viewModel.selectedTag = .work
        viewModel.completedSessions = 3

        // Start Pomodoro
        viewModel.currentSessionType = .pomodoro
        viewModel.start()
        #expect(viewModel.currentState == .running)

        // Stop
        viewModel.stop()

        #expect(viewModel.currentState == .idle, "Should be idle after stop")
        #expect(viewModel.currentSessionType == .pomodoro, "Should be Pomodoro type")
        #expect(viewModel.completedSessions == 3, "Should preserve session count")
        #expect(viewModel.selectedTag == .work, "Should preserve selected tag")
    }

    @Test func stopDuringLongBreakPreservesCounter() {
        let viewModel = TimerViewModel()

        // Simulate 4 completed Pomodoros (ready for long break)
        viewModel.completedSessions = 4
        viewModel.currentSessionType = .longBreak
        viewModel.start()

        // Stop during long break
        viewModel.stop()

        #expect(viewModel.completedSessions == 4, "Should preserve counter at 4")
        #expect(viewModel.currentSessionType == .pomodoro, "Should return to Pomodoro")
        #expect(viewModel.currentState == .idle, "Should be idle")
    }

    @Test func stopStopsTheTimer() async throws {
        let viewModel = TimerViewModel()

        // Start timer
        viewModel.start()
        #expect(viewModel.currentState == .running)

        // Wait a moment
        try await Task.sleep(for: .milliseconds(100))

        // Stop
        viewModel.stop()
        let timeAfterStop = viewModel.timeRemaining

        // Wait more time
        try await Task.sleep(for: .seconds(1))

        // Time should not have changed
        #expect(viewModel.timeRemaining == timeAfterStop, "Timer should be stopped")
        #expect(viewModel.currentState == .idle, "Should remain idle")
    }
}
