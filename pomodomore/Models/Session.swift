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

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case sessionType, completionTime, sessionNumber, selectedTag
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionType = try container.decode(SessionType.self, forKey: .sessionType)
        completionTime = try container.decode(Date.self, forKey: .completionTime)
        sessionNumber = try container.decode(Int.self, forKey: .sessionNumber)

        // Decode selectedTag as a simple string, then convert to SessionTag
        let tagId = try container.decode(String.self, forKey: .selectedTag)
        selectedTag = SessionTag(id: tagId)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionType, forKey: .sessionType)
        try container.encode(completionTime, forKey: .completionTime)
        try container.encode(sessionNumber, forKey: .sessionNumber)
        try container.encode(selectedTag.id, forKey: .selectedTag)
    }
}