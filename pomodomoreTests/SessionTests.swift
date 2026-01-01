//
//  SessionTests.swift
//  pomodomoreTests
//
//  Created on 01/09/25.
//

import Testing
import Foundation
@testable import pomodomore

@MainActor
struct SessionTests {

    // MARK: - Initialization Tests

    @Test func sessionInitializationWithDefaults() {
        let session = Session(sessionType: .pomodoro, sessionNumber: 1)

        #expect(session.sessionType == .pomodoro, "Session type should be pomodoro")
        #expect(session.sessionNumber == 1, "Session number should be 1")
        #expect(session.selectedTag == SessionTag.defaultTag, "Should use default tag when not specified")
        #expect(session.completionTime != nil, "Completion time should be set")
    }

    @Test func sessionInitializationWithCustomTag() {
        let session = Session(sessionType: .pomodoro, sessionNumber: 2, selectedTag: .work)

        #expect(session.sessionType == .pomodoro, "Session type should be pomodoro")
        #expect(session.sessionNumber == 2, "Session number should be 2")
        #expect(session.selectedTag == SessionTag.work, "Should use specified tag")
    }

    @Test func sessionInitializationAllTags() {
        for tag in SessionTag.predefinedTags {
            let session = Session(sessionType: .pomodoro, sessionNumber: 1, selectedTag: tag)
            #expect(session.selectedTag == tag, "Session should store \(tag.name) tag correctly")
        }
    }

    // MARK: - Session Number Tests

    @Test func pomodoroSessionHasNumber() {
        let session = Session(sessionType: .pomodoro, sessionNumber: 3)
        #expect(session.sessionNumber == 3, "Pomodoro session should preserve session number")
    }

    @Test func shortBreakSessionNumberIsZero() {
        let session = Session(sessionType: .shortBreak, sessionNumber: 5)
        #expect(session.sessionNumber == 0, "Short break session number should be 0")
    }

    @Test func longBreakSessionNumberIsZero() {
        let session = Session(sessionType: .longBreak, sessionNumber: 4)
        #expect(session.sessionNumber == 0, "Long break session number should be 0")
    }

    // MARK: - Session Type Tests

    @Test func pomodoroSession() {
        let session = Session(sessionType: .pomodoro)
        #expect(session.sessionType == .pomodoro, "Should create Pomodoro session")
    }

    @Test func shortBreakSession() {
        let session = Session(sessionType: .shortBreak)
        #expect(session.sessionType == .shortBreak, "Should create Short Break session")
    }

    @Test func longBreakSession() {
        let session = Session(sessionType: .longBreak)
        #expect(session.sessionType == .longBreak, "Should create Long Break session")
    }

    // MARK: - Completion Time Tests

    @Test func completionTimeIsSet() {
        let beforeCreation = Date()
        let session = Session(sessionType: .pomodoro, sessionNumber: 1)
        let afterCreation = Date()

        #expect(session.completionTime >= beforeCreation, "Completion time should be after creation start")
        #expect(session.completionTime <= afterCreation, "Completion time should be before creation end")
    }

    // MARK: - Tag Integration Tests

    @Test func pomodoroSessionWithStudyTag() {
        let session = Session(sessionType: .pomodoro, sessionNumber: 1, selectedTag: .study)
        #expect(session.selectedTag == .study, "Pomodoro should have Study tag")
        #expect(session.selectedTag.name == "Study", "Tag name should be Study")
    }

    @Test func pomodoroSessionWithWorkTag() {
        let session = Session(sessionType: .pomodoro, sessionNumber: 2, selectedTag: .work)
        #expect(session.selectedTag == .work, "Pomodoro should have Work tag")
        #expect(session.selectedTag.name == "Work", "Tag name should be Work")
    }

    @Test func breakSessionWithTag() {
        let session = Session(sessionType: .shortBreak, sessionNumber: 0, selectedTag: .research)
        #expect(session.selectedTag == .research, "Break session should preserve tag")
        #expect(session.sessionNumber == 0, "Break session number should be 0")
    }
}
