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
    @ObservedObject private var statistics = StatisticsManager.shared
    @State private var currentWeekOffset: Int = 0

    var body: some View {
        let _ = print("🎨 DashboardView rendering - Today: \(statistics.todaySessions) sessions, \(statistics.todayMinutes) minutes, Streak: \(statistics.currentStreak)")
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
        HStack(spacing: 8) {
            // Y-axis labels
            VStack(alignment: .trailing) {
                // Spacer to push 0 to bottom
                Spacer()
                // 0 label at bottom
                Text("0")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 12, alignment: .trailing)
                Spacer()
                // 2 label
                Text("2")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 12, alignment: .trailing)
                Spacer()
                // 4 label
                Text("4")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 12, alignment: .trailing)
                Spacer()
                // 6 label
                Text("6")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 12, alignment: .trailing)
                Spacer()
                // 8 label at top
                Text("8")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 12, alignment: .trailing)
                Spacer()
            }
            .frame(height: chartHeight)

            // Chart area with grid and bars
            ZStack(alignment: .bottom) {
                // Horizontal grid lines
                VStack(spacing: 0) {
                    // Grid line at 8 (top)
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 1)
                    // Spacer
                    Rectangle().fill(Color.clear).frame(height: chartHeight / 4 - 1)
                    // Grid line at 6
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 1)
                    // Spacer
                    Rectangle().fill(Color.clear).frame(height: chartHeight / 4 - 1)
                    // Grid line at 4
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 1)
                    // Spacer
                    Rectangle().fill(Color.clear).frame(height: chartHeight / 4 - 1)
                    // Grid line at 2
                    Rectangle()
                        .fill(Color.secondary.opacity(0.15))
                        .frame(height: 1)
                }

                // Chart bars
                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(0..<7, id: \.self) { day in
                        VStack(spacing: 4) {
                            // Bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(barColor(for: day))
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
                .frame(height: chartHeight)
            }
            .frame(height: chartHeight)
        }
        .padding(.vertical, 8)
    }

    private let chartHeight: CGFloat = 160

    private func barHeight(for dayIndex: Int) -> CGFloat {
        let sessions = statistics.weekSessions(for: currentWeekOffset)
        guard dayIndex < sessions.count else { return 4 }
        let count = sessions[dayIndex]

        // Minimum bar height for empty days
        guard count > 0 else { return 4 }

        // Scale: 8 sessions = full height (160), proportional scaling
        let maxSessions: CGFloat = 8
        let height = (CGFloat(count) / maxSessions) * chartHeight
        return max(height, 20) // Minimum 20px for visibility
    }

    private func barColor(for dayIndex: Int) -> Color {
        let sessions = statistics.weekSessions(for: currentWeekOffset)
        guard dayIndex < sessions.count else { return Color.accentColor.opacity(0.3) }
        let count = sessions[dayIndex]
        return count > 0 ? Color.accentColor : Color.accentColor.opacity(0.3)
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
