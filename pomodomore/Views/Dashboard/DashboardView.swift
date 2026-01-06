//
//  DashboardView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI
import Charts

// MARK: - Data Model

/// Model for weekly chart data
struct DaySessionData: Identifiable {
    let id = UUID()
    let day: String
    let sessions: Int
}

// MARK: - Dashboard View

/// Dashboard showing today's stats and weekly chart
struct DashboardView: View {
    @ObservedObject private var statistics = StatisticsManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager
    @State private var currentWeekOffset: Int = 0

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    var body: some View {
        #if DEBUG
        let _ = print("🎨 DashboardView rendering - Today: \(statistics.todaySessions) sessions, \(statistics.todayMinutes) minutes, Current Streak: \(statistics.currentStreak)")
        #endif
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
        .background(themeManager.currentTheme.colors.backgroundPrimary)
    }

    // MARK: - Today Section

    private var todaySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .appFont(size: 16, weight: .semibold)
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)

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
                    title: "Current Streak",
                    value: "\(statistics.currentStreak)",
                    icon: "🔥"
                )
            }
        }
    }

    // MARK: - This Week Section

    private var thisWeekSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(weekHeaderText)
                    .appFont(size: 16, weight: .semibold)
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                    .animation(.easeInOut(duration: 0.3), value: currentWeekOffset)

                Spacer()

                // Week navigation
                HStack(spacing: 8) {
                    Button(action: { currentWeekOffset -= 1 }) {
                        Image(systemName: "chevron.left")
                            .appFont(size: 12)
                            .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .disabled(currentWeekOffset <= -2)

                    Button(action: { currentWeekOffset += 1 }) {
                        Image(systemName: "chevron.right")
                            .appFont(size: 12)
                            .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .disabled(currentWeekOffset >= 0)
                }
            }

            // Bar chart placeholder
            weekChart
        }
    }

    private var weekHeaderText: String {
        let (start, end) = StatisticsManager.shared.getWeekDateRange(for: currentWeekOffset)

        let startStr = Self.dateFormatter.string(from: start)
        let endStr = Self.dateFormatter.string(from: end)

        if currentWeekOffset == 0 {
            return "This Week"
        } else {
            return "\(startStr) - \(endStr)"
        }
    }

    // MARK: - Week Chart

    private var weekChart: some View {
        let chartData = chartData()
        let maxSessions = max(chartData.map(\.sessions).max() ?? 0, 8)
        let yAxisStep = calculateYAxisStep(maxValue: maxSessions)
        let yAxisValues = stride(from: 0, through: maxSessions, by: yAxisStep).map { $0 }

        return Chart(chartData) { data in
            BarMark(
                x: .value("Day", data.day),
                y: .value("Sessions", data.sessions)
            )
            .foregroundStyle(data.sessions > 0 ? themeManager.currentTheme.colors.accentPrimary : themeManager.currentTheme.colors.accentPrimary.opacity(0.3))
            .cornerRadius(4)
            .annotation(position: .top, alignment: .center, spacing: 4) {
                if data.sessions > 0 {
                    Text("\(data.sessions)")
                        .appFont(size: 10)
                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                AxisValueLabel()
                    .foregroundStyle(themeManager.currentTheme.colors.textSecondary)
            }
        }
        .chartYAxis {
            AxisMarks(values: yAxisValues) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(themeManager.currentTheme.colors.borderSecondary.opacity(0.3))
                AxisValueLabel()
                    .foregroundStyle(themeManager.currentTheme.colors.textSecondary)
            }
        }
        .chartYScale(domain: 0...maxSessions)
        .frame(height: 160)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: chartData.map(\.sessions))
    }

    private func calculateYAxisStep(maxValue: Int) -> Int {
        // Calculate appropriate step size based on max value
        if maxValue <= 8 {
            return 2
        } else if maxValue <= 16 {
            return 4
        } else if maxValue <= 30 {
            return 5
        } else if maxValue <= 50 {
            return 10
        } else {
            return 20
        }
    }

    private func chartData() -> [DaySessionData] {
        let sessions = statistics.weekSessions(for: currentWeekOffset)
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        return zip(days, sessions).map { day, count in
            DaySessionData(day: day, sessions: count)
        }
    }

    private let chartHeight: CGFloat = 160
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .appFont(size: 11)
                .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .appFont(size: 32, weight: .bold)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)

                Text(icon)
                    .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 80)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ThemeManager.shared.currentTheme.colors.backgroundSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ThemeManager.shared.currentTheme.colors.borderPrimary.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Shimmer Loading View

struct ShimmerView: View {
    let width: CGFloat
    let height: CGFloat

    @State private var phase: CGFloat = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    colors: [
                        Color.gray.opacity(0.2),
                        Color.gray.opacity(0.5),
                        Color.gray.opacity(0.2)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .mask(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width * 2)
                    .offset(x: -width + phase * width * 3)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
        .frame(width: 560, height: 520)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
