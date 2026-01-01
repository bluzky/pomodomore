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

            // Session type label (will be shown for breaks in Day 9)
            // Text(viewModel.currentSessionType.displayName)

            // Timer display - live countdown
            Text(viewModel.timeFormatted)
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            Spacer()

            // Control buttons
            HStack(spacing: 12) {
                // Start/Pause toggle button
                Button(viewModel.primaryActionTitle) {
                    viewModel.toggle()
                }
                .buttonStyle(.bordered)

                // Reset button - always available
                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }

            Spacer()

            // Session indicators - 4 circles
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { _ in
                    Circle()
                        .stroke(Color.secondary, lineWidth: 2)
                        .frame(width: 12, height: 12)
                }
            }
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
