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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Today Section
                todaySection

                // This Week Section
                thisWeekSection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
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
                    value: "4",
                    icon: "🍅"
                )

                StatCard(
                    title: "Minutes",
                    value: "96",
                    icon: "⏱"
                )

                StatCard(
                    title: "Streak",
                    value: "12",
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
            ForEach(0..<7) { day in
                VStack(spacing: 4) {
                    // Bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: CGFloat.random(in: 30...100))

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
        VStack(alignment: .leading, spacing: 8) {
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
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 80)
        .padding(12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
        .frame(width: 560, height: 520)
}
