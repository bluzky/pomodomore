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

    // MARK: - Duration Tests (MainActor)

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

    // MARK: - Non-Isolated Duration Tests

    @Test func pomodoroDurationFromConfig() {
        let sessionType = SessionType.pomodoro
        let config = SessionDurations.defaultDurations
        #expect(sessionType.duration(from: config) == 1500, "Pomodoro should be 25 minutes from default config")
    }

    @Test func shortBreakDurationFromConfig() {
        let sessionType = SessionType.shortBreak
        let config = SessionDurations.defaultDurations
        #expect(sessionType.duration(from: config) == 300, "Short Break should be 5 minutes from default config")
    }

    @Test func longBreakDurationFromConfig() {
        let sessionType = SessionType.longBreak
        let config = SessionDurations.defaultDurations
        #expect(sessionType.duration(from: config) == 900, "Long Break should be 15 minutes from default config")
    }

    @Test func testDurations() {
        let sessionType = SessionType.pomodoro
        let testConfig = SessionDurations.testDurations
        #expect(sessionType.duration(from: testConfig) == 10, "Pomodoro test duration should be 10 seconds")
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
