//
//  TimerView.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import SwiftUI

struct TimerView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Timer display - large "25:00" text
            Text("25:00")
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .foregroundColor(.primary)

            Spacer()

            // Control buttons
            HStack(spacing: 12) {
                Button("Start") {
                    print("Start tapped")
                }
                .buttonStyle(.bordered)

                Button("Pause") {
                    print("Pause tapped")
                }
                .buttonStyle(.bordered)

                Button("Reset") {
                    print("Reset tapped")
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
