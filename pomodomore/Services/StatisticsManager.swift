//
//  StatisticsManager.swift
//  pomodomore
//
//  Created on 01/14/26.
//

import Foundation
import Combine

#if DEBUG
private let isDebug = true
#else
private let isDebug = false
#endif

// MARK: - Statistics Manager

/// Aggregates session data for Dashboard statistics
final class StatisticsManager: ObservableObject {
    /// Shared singleton instance
    static let shared = StatisticsManager()

    /// Storage manager for session data
    private let storage = StorageManager.shared

    /// Calendar for date calculations
    private let calendar = Calendar.current

    /// Cached sessions (loaded once, refreshed on demand)
    private var cachedSessions: [Session]?

    /// Load sessions with caching
    private func getSessions() -> [Session] {
        if let cached = cachedSessions {
            if isDebug { print("📊 StatisticsManager: Using cached sessions (\(cached.count) sessions)") }
            return cached
        }
        let sessions = storage.loadSessions()
        cachedSessions = sessions
        if isDebug { print("📊 StatisticsManager: Loaded \(sessions.count) sessions from storage") }
        if sessions.count > 0 {
            if isDebug { print("   First session: \(sessions[0].completionTime)") }
            if isDebug { print("   Last session: \(sessions[sessions.count-1].completionTime)") }
        }
        return sessions
    }

    // MARK: - Computed Properties

    /// Number of completed Pomodoro sessions today
    var todaySessions: Int {
        let start = startOfToday()
        let end = endOfToday()
        let todaySessions = filterSessions(from: start, to: end)
        let count = todaySessions.filter { $0.sessionType == .pomodoro }.count
        if isDebug { print("📊 StatisticsManager.todaySessions: \(count) (from \(start) to \(end))") }
        return count
    }

    /// Total focus minutes from Pomodoro sessions today
    var todayMinutes: Int {
        let todaySessions = filterSessions(from: startOfToday(), to: endOfToday())
        let pomodoroSessions = todaySessions.filter { $0.sessionType == .pomodoro }
        let totalSeconds = pomodoroSessions.reduce(0) { sum, session in
            sum + session.duration
        }
        return totalSeconds / 60
    }

    /// Current streak of consecutive days with at least one Pomodoro session
    var currentStreak: Int {
        let sessions = getSessions()
        let sortedDates = Set(sessions
            .filter { $0.sessionType == .pomodoro }
            .map { calendar.startOfDay(for: $0.completionTime) }
        ).sorted(by: >)

        guard !sortedDates.isEmpty else { return 0 }

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        // Check if today has sessions, otherwise start from yesterday
        if !sortedDates.contains(currentDate) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        for date in sortedDates {
            if date == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }

        return streak
    }

    /// Sessions per day for the current week (Mon-Sun)
    /// Returns array of 7 integers, indexed 0 = Monday
    var weekSessions: [Int] {
        let (weekStart, weekEnd) = currentWeekRange()
        let weekSessions = filterSessions(from: weekStart, to: weekEnd)

        // Create array for 7 days, initialized to 0
        var dailyCounts = Array(repeating: 0, count: 7)

        for session in weekSessions where session.sessionType == .pomodoro {
            if let weekday = weekdayIndex(for: session.completionTime) {
                dailyCounts[weekday] += 1
            }
        }

        return dailyCounts
    }

    /// Sessions per day for a specific week offset
    /// offset: 0 = current week, -1 = previous week, 1 = next week
    func weekSessions(for offset: Int) -> [Int] {
        let (weekStart, weekEnd) = weekRange(for: offset)
        let weekSessions = filterSessions(from: weekStart, to: weekEnd)

        var dailyCounts = Array(repeating: 0, count: 7)

        for session in weekSessions where session.sessionType == .pomodoro {
            if let weekday = weekdayIndex(for: session.completionTime) {
                dailyCounts[weekday] += 1
            }
        }

        if isDebug {
            print("📊 StatisticsManager.weekSessions(offset: \(offset))")
            print("   Week range: \(weekStart) to \(weekEnd)")
            print("   Found \(weekSessions.count) sessions in range")
            print("   Daily counts: \(dailyCounts)")
        }

        return dailyCounts
    }

    // MARK: - Date Helpers

    /// Get the weekday index (0 = Monday, 6 = Sunday) for a date
    private func weekdayIndex(for date: Date) -> Int? {
        let weekday = calendar.component(.weekday, from: date)
        // Convert from Sunday-based (1) to Monday-based (0)
        // Sunday = 1, Monday = 2, ..., Saturday = 7
        // We want: Monday = 0, Tuesday = 1, ..., Sunday = 6
        return (weekday + 5) % 7
    }

    /// Start of today (midnight)
    private func startOfToday() -> Date {
        calendar.startOfDay(for: Date())
    }

    /// End of today (23:59:59)
    private func endOfToday() -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return calendar.date(byAdding: components, to: startOfToday())!
    }

    /// Current week range (Monday to Sunday)
    private func currentWeekRange() -> (start: Date, end: Date) {
        weekRange(for: 0)
    }

    /// Week range for a specific offset
    private func weekRange(for offset: Int) -> (start: Date, end: Date) {
        let today = calendar.startOfDay(for: Date())

        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        let weekOffset = offset * 7

        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday + weekOffset, to: today) else {
            return (today, today)
        }

        guard let sunday = calendar.date(byAdding: .day, value: 6, to: monday) else {
            return (monday, monday)
        }

        var sundayComponents = calendar.dateComponents([.year, .month, .day], from: sunday)
        sundayComponents.hour = 23
        sundayComponents.minute = 59
        sundayComponents.second = 59

        let endOfSunday = calendar.date(from: sundayComponents) ?? sunday

        return (monday, endOfSunday)
    }

    // MARK: - Session Filtering

    /// Filter sessions within a date range
    private func filterSessions(from start: Date, to end: Date) -> [Session] {
        let sessions = getSessions()
        return sessions.filter { session in
            session.completionTime >= start && session.completionTime <= end
        }
    }

    // MARK: - Refresh

    /// Force reload of session data and notify observers (triggers UI updates)
    func refresh() {
        cachedSessions = nil
        objectWillChange.send()
    }
}
