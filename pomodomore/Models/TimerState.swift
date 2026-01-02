//
//  TimerState.swift
//  pomodomore
//
//  Created on 01/02/25.
//

import Foundation

/// Represents the current state of the Pomodoro timer
enum TimerState {
    /// Timer is idle, not running (initial state or after reset)
    case idle

    /// Timer is actively counting down
    case running

    /// Timer is paused (can be resumed)
    case paused

    /// Timer has completed countdown (reached 00:00)
    case completed
}
