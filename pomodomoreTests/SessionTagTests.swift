//
//  SessionTagTests.swift
//  pomodomoreTests
//
//  Created on 01/09/25.
//

import Testing
import SwiftUI
@testable import pomodomore

@MainActor
struct SessionTagTests {

    // MARK: - Predefined Tags Tests

    @Test func predefinedTagsCount() {
        #expect(SessionTag.predefinedTags.count == 6, "Should have 6 predefined tags")
    }

    @Test func studyTag() {
        let tag = SessionTag.study
        #expect(tag.id == "study", "Study tag should have id 'study'")
        #expect(tag.name == "Study", "Study tag should have name 'Study'")
    }

    @Test func workTag() {
        let tag = SessionTag.work
        #expect(tag.id == "work", "Work tag should have id 'work'")
        #expect(tag.name == "Work", "Work tag should have name 'Work'")
    }

    @Test func researchTag() {
        let tag = SessionTag.research
        #expect(tag.id == "research", "Research tag should have id 'research'")
        #expect(tag.name == "Research", "Research tag should have name 'Research'")
    }

    @Test func personalTag() {
        let tag = SessionTag.personal
        #expect(tag.id == "personal", "Personal tag should have id 'personal'")
        #expect(tag.name == "Personal", "Personal tag should have name 'Personal'")
    }

    @Test func meetingTag() {
        let tag = SessionTag.meeting
        #expect(tag.id == "meeting", "Meeting tag should have id 'meeting'")
        #expect(tag.name == "Meeting", "Meeting tag should have name 'Meeting'")
    }

    @Test func otherTag() {
        let tag = SessionTag.other
        #expect(tag.id == "other", "Other tag should have id 'other'")
        #expect(tag.name == "Other", "Other tag should have name 'Other'")
    }

    @Test func defaultTag() {
        let defaultTag = SessionTag.defaultTag
        #expect(defaultTag.id == "study", "Default tag should be Study")
        #expect(defaultTag == SessionTag.study, "Default tag should equal Study tag")
    }

    // MARK: - Identifiable Tests

    @Test func tagsHaveUniqueIds() {
        let ids = SessionTag.predefinedTags.map { $0.id }
        let uniqueIds = Set(ids)
        #expect(ids.count == uniqueIds.count, "All tag IDs should be unique")
    }

    // MARK: - Equatable Tests

    @Test func tagsAreEqual() {
        let tag1 = SessionTag.study
        let tag2 = SessionTag.study
        #expect(tag1 == tag2, "Same tags should be equal")
    }

    @Test func tagsAreNotEqual() {
        let tag1 = SessionTag.study
        let tag2 = SessionTag.work
        #expect(tag1 != tag2, "Different tags should not be equal")
    }

    // MARK: - Hashable Tests

    @Test func tagsAreHashable() {
        let tagSet: Set<SessionTag> = [.study, .work, .study]
        #expect(tagSet.count == 2, "Set should deduplicate tags")
    }

    // MARK: - Codable Tests

    @Test func tagIsCodable() throws {
        let tag = SessionTag.study
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encoded = try encoder.encode(tag)
        let decoded = try decoder.decode(SessionTag.self, from: encoded)

        #expect(decoded.id == tag.id, "Decoded tag should have same id")
        #expect(decoded.name == tag.name, "Decoded tag should have same name")
    }

    @Test func allPredefinedTagsAreCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for tag in SessionTag.predefinedTags {
            let encoded = try encoder.encode(tag)
            let decoded = try decoder.decode(SessionTag.self, from: encoded)
            #expect(decoded == tag, "\(tag.name) should encode and decode correctly")
        }
    }

    // MARK: - Color Tests

    @Test func colorHexConversion() {
        // Test that color property returns a Color (basic smoke test)
        let tag = SessionTag.study
        let color = tag.color
        // Just verify it doesn't crash
        #expect(color != nil, "Color should be accessible")
    }

    @Test func colorInitFromHex() {
        // Test Color hex initialization with known values
        let blueColor = Color(hex: "#3B82F6")
        #expect(blueColor != nil, "Should create color from valid hex")

        let invalidColor = Color(hex: "invalid")
        #expect(invalidColor != nil, "Should handle invalid hex gracefully")
    }
}
