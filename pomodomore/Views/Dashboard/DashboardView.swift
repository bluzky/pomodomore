//
//  DashboardView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - Dashboard View

/// Dashboard showing today's stats and weekly chart
struct DashboardView: View {
    @State private var currentWeekOffset: Int = 0

    /// Statistics manager for real data
    private let statistics = StatisticsManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Today Section
                todaySection

                // This Week Section
                thisWeekSection

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Today Section

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today")
                .font(.system(size: 16, weight: .semibold))

            HStack(spacing: 12) {
                StatCard(
                    title: "Sessions",
                    value: "\(statistics.todaySessions)",
                    icon: "🍅"
                )

                StatCard(
                    title: "Minutes",
                    value: "\(statistics.todayMinutes)",
                    icon: "⏱"
                )

                StatCard(
                    title: "Streak",
                    value: "\(statistics.currentStreak)",
                    icon: "🔥"
                )
            }
        }
    }

    // MARK: - This Week Section

    private var thisWeekSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Week")
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                // Week navigation
                HStack(spacing: 8) {
                    Button(action: { currentWeekOffset -= 1 }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)

                    Button(action: { currentWeekOffset += 1 }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(currentWeekOffset >= 0)
                }
            }

            // Bar chart placeholder
            weekChart
        }
    }

    // MARK: - Week Chart

    private var weekChart: some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(0..<7, id: \.self) { day in
                VStack(spacing: 4) {
                    // Bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: barHeight(for: day))

                    // Day label
                    Text(dayLabel(for: day))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding(.vertical, 8)
    }

    private func barHeight(for dayIndex: Int) -> CGFloat {
        let sessions = statistics.weekSessions(for: currentWeekOffset)
        guard dayIndex < sessions.count else { return 0 }
        let count = sessions[dayIndex]
        guard count > 0 else { return 4 }
        // Scale: max 8 sessions = 100 height, min 1 session = 20 height
        return CGFloat(max(20, min(100, count * 15)))
    }

    // MARK: - Helpers

    private func dayLabel(for index: Int) -> String {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days[index]
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold))

                Text(icon)
                    .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 80)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
        .frame(width: 560, height: 520)
}
