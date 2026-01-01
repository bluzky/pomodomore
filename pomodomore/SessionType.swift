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

    /// Duration of the session in seconds (from ConfigManager)
    @MainActor
    var duration: Int {
        ConfigManager.shared.duration(for: self)
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
