//
//  TimerView.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Timer display - live countdown
            Text(viewModel.timeFormatted)
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            Spacer()

            // Control buttons
            HStack(spacing: 12) {
                // Start/Pause toggle button
                Button(viewModel.currentState == .running ? "Pause" : "Start") {
                    if viewModel.currentState == .running {
                        viewModel.pause()
                    } else {
                        viewModel.start()
                    }
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
    TimerView()
        .frame(width: 320, height: 200)
}
