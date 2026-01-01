//
//  TimerView.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Session label area - dynamic based on state
            if viewModel.currentState == .idle && viewModel.currentSessionType == .pomodoro {
                // Idle Pomodoro: Tag picker
                Picker("Tag", selection: $viewModel.selectedTag) {
                    ForEach(SessionTag.predefinedTags) { tag in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(tag.color)
                                .frame(width: 8, height: 8)
                            Text(tag.name)
                        }
                        .tag(tag)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            } else if viewModel.currentSessionType == .pomodoro {
                // Active/Paused Pomodoro: Show selected tag with color circle
                HStack(spacing: 6) {
                    Circle()
                        .fill(viewModel.selectedTag.color)
                        .frame(width: 8, height: 8)
                    Text(viewModel.selectedTag.name)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.primary)
                }
            } else {
                // Break sessions: Show break type label
                Text(viewModel.currentSessionType.displayName)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
            }

            // Timer display - live countdown with dynamic color
            Text(viewModel.timeFormatted)
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .foregroundColor(viewModel.timerColor)

            Spacer()

            // Control buttons - consistent for all session types
            HStack(spacing: 12) {
                // Start/Pause toggle button
                Button(viewModel.primaryActionTitle) {
                    viewModel.toggle()
                }
                .buttonStyle(.bordered)

                // Stop button - ends session and returns to idle Pomodoro
                Button("Stop") {
                    viewModel.stop()
                }
                .buttonStyle(.bordered)
            }

            Spacer()

            // Session indicators - 4 circles showing cycle progress
            SessionIndicatorsView(completedSessions: viewModel.completedSessions)
                .padding(.bottom, 20)
        }
        .frame(width: 320, height: 200)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// Preview for development
#Preview {
    TimerView(viewModel: WindowManager.shared.timerViewModel)
        .frame(width: 320, height: 200)
}
