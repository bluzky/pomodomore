//
//  SessionIndicatorsView.swift
//  pomodomore
//
//  Created on 01/08/25.
//

import SwiftUI

/// Visual indicator showing Pomodoro cycle progress (4 circles)
struct SessionIndicatorsView: View {
    /// Number of completed Pomodoro sessions (0-4)
    let completedSessions: Int

    /// Clamped session count ensuring valid range (0...4)
    private var clampedSessions: Int {
        min(max(completedSessions, 0), 4)
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < clampedSessions ? Color.primary : Color.clear)
                    .overlay(
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2)
                    )
                    .frame(width: 12, height: 12)
            }
        }
    }
}

// Preview for development
#Preview("No Sessions") {
    SessionIndicatorsView(completedSessions: 0)
        .padding()
}

#Preview("One Session") {
    SessionIndicatorsView(completedSessions: 1)
        .padding()
}

#Preview("Two Sessions") {
    SessionIndicatorsView(completedSessions: 2)
        .padding()
}

#Preview("Three Sessions") {
    SessionIndicatorsView(completedSessions: 3)
        .padding()
}

#Preview("Four Sessions") {
    SessionIndicatorsView(completedSessions: 4)
        .padding()
}
