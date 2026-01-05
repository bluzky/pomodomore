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
                    icon: "🍅",
                    isLoading: statistics.isLoading
                )

                StatCard(
                    title: "Minutes",
                    value: "\(statistics.todayMinutes)",
                    icon: "⏱",
                    isLoading: statistics.isLoading
                )

                StatCard(
                    title: "Current Streak",
                    value: "\(statistics.currentStreak)",
                    icon: "🔥",
                    isLoading: statistics.isLoading
                )
            }
        }
    }

    // MARK: - This Week Section

    private var thisWeekSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(weekHeaderText)
                    .font(.system(size: 16, weight: .semibold))
                    .animation(.easeInOut(duration: 0.3), value: currentWeekOffset)

                Spacer()

                // Week navigation
                HStack(spacing: 8) {
                    Button(action: { currentWeekOffset -= 1 }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(currentWeekOffset <= -2)

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

        return Chart(chartData) { data in
            BarMark(
                x: .value("Day", data.day),
                y: .value("Sessions", data.sessions)
            )
            .foregroundStyle(data.sessions > 0 ? Color.accentColor : Color.accentColor.opacity(0.3))
            .cornerRadius(4)
            .annotation(position: .top, alignment: .center, spacing: 4) {
                if data.sessions > 0 {
                    Text("\(data.sessions)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0))
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: [0, 2, 4, 6, 8]) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.secondary.opacity(0.15))
                AxisValueLabel()
            }
        }
        .chartYScale(domain: 0...8)
        .frame(height: 160)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: chartData.map(\.sessions))
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
    var isLoading: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if isLoading {
                loadingView
            } else {
                contentView
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

    private var contentView: some View {
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
    }

    private var loadingView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                ShimmerView(width: 40, height: 38)
                    .frame(width: 40, height: 38)

                ShimmerView(width: 20, height: 20)
                    .frame(width: 20, height: 20)
            }
        }
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
}
