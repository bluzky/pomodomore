//
//  PomodoroSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - Pomodoro Settings View

/// Pomodoro timer configuration settings
struct PomodoroSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Session Durations
                durationsSection

                // Auto-Start
                autoStartSection

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .frame(width: 520, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Durations Section

    private var durationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Durations")
                .font(.system(size: 14, weight: .semibold))

            VStack(spacing: 12) {
                DurationStepper(
                    label: "Pomodoro",
                    value: $settingsManager.settings.pomodoro.pomodoroDuration,
                    range: 60...3600,
                    step: 60
                )

                DurationStepper(
                    label: "Short Break",
                    value: $settingsManager.settings.pomodoro.shortBreakDuration,
                    range: 60...1800,
                    step: 60
                )

                DurationStepper(
                    label: "Long Break",
                    value: $settingsManager.settings.pomodoro.longBreakDuration,
                    range: 60...3600,
                    step: 60
                )

                HStack {
                    Text("Long Break Interval")
                        .font(.system(size: 13))
                        .frame(width: 150, alignment: .leading)

                    Stepper(
                        value: $settingsManager.settings.pomodoro.longBreakInterval,
                        in: 2...10
                    ) {
                        Text("\(settingsManager.settings.pomodoro.longBreakInterval) sessions")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Auto-Start Section

    private var autoStartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Auto-Start")
                .font(.system(size: 14, weight: .semibold))

            Toggle("Automatically start next session", isOn: $settingsManager.settings.pomodoro.autoStartNextSession)
                .toggleStyle(.switch)
        }
    }
}

// MARK: - Duration Stepper

struct DurationStepper: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int

    private var minutes: Int {
        value / 60
    }

    private var minutesBinding: Binding<Int> {
        Binding(
            get: { value / 60 },
            set: { value = $0 * 60 }
        )
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .frame(width: 150, alignment: .leading)

            Stepper(
                value: minutesBinding,
                in: (range.lowerBound / 60)...(range.upperBound / 60),
                step: step / 60
            ) {
                Text("\(minutes) min")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .frame(width: 60, alignment: .trailing)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PomodoroSettingsView()
        .frame(width: 560, height: 520)
}
