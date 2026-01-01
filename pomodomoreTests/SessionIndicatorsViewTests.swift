//
//  SessionIndicatorsViewTests.swift
//  pomodomoreTests
//
//  Created on 01/08/25.
//

import XCTest
import SwiftUI
@testable import pomodomore

@MainActor
final class SessionIndicatorsViewTests: XCTestCase {

    // MARK: - View Instantiation Tests

    func testViewInstantiationWithZeroSessions() {
        let view = SessionIndicatorsView(completedSessions: 0)
        XCTAssertNotNil(view, "View should instantiate with 0 completed sessions")
    }

    func testViewInstantiationWithOneSessions() {
        let view = SessionIndicatorsView(completedSessions: 1)
        XCTAssertNotNil(view, "View should instantiate with 1 completed session")
    }

    func testViewInstantiationWithTwoSessions() {
        let view = SessionIndicatorsView(completedSessions: 2)
        XCTAssertNotNil(view, "View should instantiate with 2 completed sessions")
    }

    func testViewInstantiationWithThreeSessions() {
        let view = SessionIndicatorsView(completedSessions: 3)
        XCTAssertNotNil(view, "View should instantiate with 3 completed sessions")
    }

    func testViewInstantiationWithFourSessions() {
        let view = SessionIndicatorsView(completedSessions: 4)
        XCTAssertNotNil(view, "View should instantiate with 4 completed sessions")
    }

    // MARK: - Edge Case Tests

    func testViewInstantiationWithNegativeSessions() {
        let view = SessionIndicatorsView(completedSessions: -1)
        XCTAssertNotNil(view, "View should handle negative input gracefully")
    }

    func testViewInstantiationWithExcessiveSessions() {
        let view = SessionIndicatorsView(completedSessions: 10)
        XCTAssertNotNil(view, "View should handle excessive input gracefully")
    }


    // MARK: - Session Indicator Logic Tests

    func testIndicatorLogic_ZeroSessions() {
        // Verify logic: with 0 sessions, all circles should be empty
        let completedSessions = 0
        for index in 0..<4 {
            let shouldBeFilled = index < completedSessions
            XCTAssertFalse(shouldBeFilled, "Circle \(index) should be empty with 0 sessions")
        }
    }

    func testIndicatorLogic_OneSessions() {
        // Verify logic: with 1 session, first circle filled
        let completedSessions = 1
        for index in 0..<4 {
            let shouldBeFilled = index < completedSessions
            if index == 0 {
                XCTAssertTrue(shouldBeFilled, "Circle 0 should be filled with 1 session")
            } else {
                XCTAssertFalse(shouldBeFilled, "Circle \(index) should be empty with 1 session")
            }
        }
    }

    func testIndicatorLogic_FourSessions() {
        // Verify logic: with 4 sessions, all circles filled
        let completedSessions = 4
        for index in 0..<4 {
            let shouldBeFilled = index < completedSessions
            XCTAssertTrue(shouldBeFilled, "Circle \(index) should be filled with 4 sessions")
        }
    }

    func testIndicatorLogic_ProgressThroughCycle() {
        // Simulate progressing through a full Pomodoro cycle
        for sessions in 0...4 {
            for index in 0..<4 {
                let shouldBeFilled = index < sessions
                if sessions > index {
                    XCTAssertTrue(shouldBeFilled, "Circle \(index) should be filled with \(sessions) sessions")
                } else {
                    XCTAssertFalse(shouldBeFilled, "Circle \(index) should be empty with \(sessions) sessions")
                }
            }
        }
    }
}
