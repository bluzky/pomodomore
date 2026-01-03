//
//  Session.swift
//  pomodomore
//
//  Created on 01/07/25.
//

import Foundation

/// Represents a completed Pomodoro session with metadata
struct Session: Codable {
    /// The type of session that was completed
    let sessionType: SessionType

    /// When the session was completed
    let completionTime: Date

    /// Which Pomodoro in the current cycle (1-4), 0 for break sessions
    let sessionNumber: Int

    /// The tag/category selected for this session (e.g., Study, Work)
    let selectedTag: SessionTag

    init(sessionType: SessionType, sessionNumber: Int = 0, selectedTag: SessionTag = .defaultTag) {
        self.sessionType = sessionType
        self.completionTime = Date()
        self.sessionNumber = sessionType == .pomodoro ? sessionNumber : 0
        self.selectedTag = selectedTag
    }
}