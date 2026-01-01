//
//  SessionType.swift
//  pomodomore
//
//  Created on 01/06/25.
//

import Foundation

/// Represents the type of Pomodoro session
enum SessionType {
    /// Standard 25-minute Pomodoro work session
    case pomodoro

    /// 5-minute short break between Pomodoros
    case shortBreak

    /// 15-minute long break after completing 4 Pomodoros
    case longBreak

    /// Duration of the session in seconds
    var duration: Int {
        switch self {
        case .pomodoro:
            return 10  // TESTING: 10 seconds (production: 1500 = 25 minutes)
        case .shortBreak:
            return 5   // TESTING: 5 seconds (production: 300 = 5 minutes)
        case .longBreak:
            return 8   // TESTING: 8 seconds (production: 900 = 15 minutes)
        }
    }

    /// Display name for the session type
    /// Returns empty string for Pomodoro (shown as timer only)
    var displayName: String {
        switch self {
        case .pomodoro:
            return ""
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }
}
