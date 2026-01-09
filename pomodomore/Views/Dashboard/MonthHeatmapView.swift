//
//  MonthHeatmapView.swift
//  pomodomore
//
//  Created on 01/09/26.
//

import SwiftUI

// MARK: - Month Heatmap View

/// Calendar heatmap showing session activity for the month
struct MonthHeatmapView: View {
    @ObservedObject private var statistics = StatisticsManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentMonthOffset: Int = 0

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with month name and navigation
            header

            // Day of week labels
            dayLabels

            // Calendar grid
            calendarGrid
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text(monthHeaderText)
                .appFont(size: 16, weight: .semibold)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                .animation(.easeInOut(duration: 0.3), value: currentMonthOffset)

            Spacer()

            // Month navigation
            HStack(spacing: 8) {
                Button(action: { currentMonthOffset -= 1 }) {
                    Image(systemName: "chevron.left")
                        .appFont(size: 12)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
                .buttonStyle(.plain)
                .disabled(currentMonthOffset <= -12)

                Button(action: { currentMonthOffset += 1 }) {
                    Image(systemName: "chevron.right")
                        .appFont(size: 12)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
                .buttonStyle(.plain)
                .disabled(currentMonthOffset >= 0)
            }
        }
    }

    private var monthHeaderText: String {
        let (start, _) = statistics.getMonthDateRange(for: currentMonthOffset)
        return Self.monthFormatter.string(from: start)
    }

    // MARK: - Day Labels

    private var dayLabels: some View {
        HStack(spacing: 4) {
            ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                Text(day)
                    .appFont(size: 10)
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Calendar Grid

    private var calendarGrid: some View {
        let monthData = getMonthData()

        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(monthData) { dayData in
                if dayData.day > 0 {
                    DayCell(
                        day: dayData.day,
                        sessions: dayData.sessions,
                        isToday: dayData.isToday,
                        isFuture: dayData.isFuture,
                        maxSessions: monthData.map(\.sessions).max() ?? 1
                    )
                } else {
                    // Empty cell for alignment
                    Color.clear
                        .frame(height: 32)
                }
            }
        }
    }

    // MARK: - Data Helpers

    private struct DayData: Identifiable {
        let id = UUID()
        let day: Int
        let sessions: Int
        let isToday: Bool
        let isFuture: Bool
    }

    private func getMonthData() -> [DayData] {
        let (monthStart, _) = statistics.getMonthDateRange(for: currentMonthOffset)
        let sessionsMap = statistics.monthSessions(for: currentMonthOffset)

        // Get first day of month and number of days
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30

        // Convert weekday to Monday-based index (0 = Monday)
        let firstWeekdayIndex = (firstWeekday + 5) % 7

        var data: [DayData] = []

        // Add empty cells for days before month starts
        for _ in 0..<firstWeekdayIndex {
            data.append(DayData(day: 0, sessions: 0, isToday: false, isFuture: false))
        }

        // Add cells for each day of the month
        let today = calendar.startOfDay(for: Date())
        for day in 1...daysInMonth {
            guard let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) else {
                continue
            }
            let isToday = calendar.isDate(dayDate, inSameDayAs: today)
            let isFuture = dayDate > today
            let sessions = sessionsMap[day] ?? 0
            data.append(DayData(day: day, sessions: sessions, isToday: isToday, isFuture: isFuture))
        }

        return data
    }
}

// MARK: - Day Cell

struct DayCell: View {
    let day: Int
    let sessions: Int
    let isToday: Bool
    let isFuture: Bool
    let maxSessions: Int

    @EnvironmentObject var themeManager: ThemeManager
    @State private var isHovered = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(cellColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .strokeBorder(
                            isToday ? themeManager.currentTheme.colors.accentPrimary : Color.clear,
                            lineWidth: isToday ? 2 : 0
                        )
                )

            Text("\(day)")
                .appFont(size: 10, weight: sessions > 0 ? .semibold : .regular)
                .foregroundColor(textColor)
        }
        .frame(height: 32)
        .onHover { hovering in
            if !isFuture {
                isHovered = hovering
            }
        }
        .popover(isPresented: $isHovered, arrowEdge: .top) {
            Text(tooltipText)
                .appFont(size: 11)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
        }
    }

    private var tooltipText: String {
        if sessions == 0 {
            return "No sessions"
        } else if sessions == 1 {
            return "1 session"
        } else {
            return "\(sessions) sessions"
        }
    }

    private var cellColor: Color {
        if sessions == 0 {
            return themeManager.currentTheme.colors.backgroundSecondary
        }

        let intensity = CGFloat(sessions) / CGFloat(max(maxSessions, 1))
        return themeManager.currentTheme.colors.accentPrimary.opacity(0.2 + (intensity * 0.8))
    }

    private var textColor: Color {
        if sessions == 0 {
            return themeManager.currentTheme.colors.textSecondary
        }
        return themeManager.currentTheme.colors.textPrimary
    }
}

// MARK: - Preview

#Preview {
    MonthHeatmapView()
        .frame(width: 560)
        .padding(24)
        .background(ThemeManager.shared.currentTheme.colors.backgroundPrimary)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
