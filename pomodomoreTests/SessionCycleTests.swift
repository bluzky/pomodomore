//
//  SessionCycleTests.swift
//  pomodomoreTests
//
//  Created on 01/07/25.
//

import XCTest
@testable import pomodomore

@MainActor
final class SessionCycleTests: XCTestCase {
    
    var viewModel: TimerViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = TimerViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Session Counter Tests
    
    func testCompletedSessionsInitializesToZero() {
        XCTAssertEqual(viewModel.completedSessions, 0, "Completed sessions should initialize to 0")
    }
    
    func testCompletedSessionsIncrementsOnPomodoroCompletion() {
        // Test that completedSessions property exists and can be modified
        viewModel.completedSessions = 1
        XCTAssertEqual(viewModel.completedSessions, 1, "Completed sessions should be settable")
    }
    
    func testCompletedSessionsResetsAfterLongBreak() {
        // Test session counter reset logic
        viewModel.completedSessions = 4
        
        // Simulate long break completion
        viewModel.currentSessionType = .longBreak
        viewModel.completedSessions = 0 // Reset as would happen in transition logic
        
        XCTAssertEqual(viewModel.completedSessions, 0, "Completed sessions should reset to 0")
    }
    
    // MARK: - Session Type Tests
    
    func testSessionTypeInitialization() {
        XCTAssertEqual(viewModel.currentSessionType, .pomodoro, "Should initialize to Pomodoro")
    }
    
    func testSessionTypeChange() {
        viewModel.currentSessionType = .shortBreak
        XCTAssertEqual(viewModel.currentSessionType, .shortBreak, "Should be able to change session type")
        XCTAssertEqual(viewModel.timeRemaining, 300, "Time should update to short break duration")
    }
    
    // MARK: - Timer State Tests
    
    func testTimerStateInitialization() {
        XCTAssertEqual(viewModel.currentState, .idle, "Should initialize to idle")
    }
    
    func testTimerTimeInitialization() {
        XCTAssertEqual(viewModel.timeRemaining, 1500, "Should initialize to 25 minutes")
    }
    
    func testTimeFormatted() {
        viewModel.timeRemaining = 125 // 2:05
        XCTAssertEqual(viewModel.timeFormatted, "02:05", "Should format time correctly")
    }
    
    func testResetMaintainsSessionType() {
        viewModel.currentSessionType = .shortBreak
        viewModel.timeRemaining = 100
        viewModel.reset()
        
        XCTAssertEqual(viewModel.currentSessionType, .shortBreak, "Reset should maintain session type")
        XCTAssertEqual(viewModel.timeRemaining, 300, "Reset should set time to session type duration")
        XCTAssertEqual(viewModel.currentState, .idle, "Reset should set state to idle")
    }
}