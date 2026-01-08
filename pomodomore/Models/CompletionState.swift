//
//  CompletionState.swift
//  pomodomore
//
//  Created on January 8, 2026.
//  Week 5, Day 6: Session completion floating view
//

import Foundation

// MARK: - Completion State

/// Represents the state of the session completion window
enum CompletionState: Equatable {
    /// No completion window showing
    case hidden

    /// Show Pomodoro completion with break options
    case pomodoroComplete

    /// Show break completion with Pomodoro options
    case breakComplete

    /// Break countdown visible in completion window
    case breakRunning(timeRemaining: Int)

    // MARK: - Equatable

    static func == (lhs: CompletionState, rhs: CompletionState) -> Bool {
        switch (lhs, rhs) {
        case (.hidden, .hidden):
            return true
        case (.pomodoroComplete, .pomodoroComplete):
            return true
        case (.breakComplete, .breakComplete):
            return true
        case (.breakRunning(let lhsTime), .breakRunning(let rhsTime)):
            return lhsTime == rhsTime
        default:
            return false
        }
    }
}
