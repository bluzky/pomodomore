//
//  SessionTypeTests.swift
//  pomodomoreTests
//
//  Created on 01/06/25.
//

import Testing
@testable import pomodomore

@MainActor
struct SessionTypeTests {

    // MARK: - Duration Tests

    @Test func pomodoroDuration() {
        let sessionType = SessionType.pomodoro
        #expect(sessionType.duration == 1500, "Pomodoro should be 25 minutes (1500 seconds)")
    }

    @Test func shortBreakDuration() {
        let sessionType = SessionType.shortBreak
        #expect(sessionType.duration == 300, "Short Break should be 5 minutes (300 seconds)")
    }

    @Test func longBreakDuration() {
        let sessionType = SessionType.longBreak
        #expect(sessionType.duration == 900, "Long Break should be 15 minutes (900 seconds)")
    }

    // MARK: - Display Name Tests

    @Test func pomodoroDisplayName() {
        let sessionType = SessionType.pomodoro
        #expect(sessionType.displayName == "", "Pomodoro should have empty display name")
    }

    @Test func shortBreakDisplayName() {
        let sessionType = SessionType.shortBreak
        #expect(sessionType.displayName == "Short Break", "Short Break display name should be 'Short Break'")
    }

    @Test func longBreakDisplayName() {
        let sessionType = SessionType.longBreak
        #expect(sessionType.displayName == "Long Break", "Long Break display name should be 'Long Break'")
    }
}
