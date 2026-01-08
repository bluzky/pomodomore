//
//  CompletionButton.swift
//  pomodomore
//
//  Created on January 8, 2026.
//  Week 5, Day 6: Session completion floating view
//

import SwiftUI

// MARK: - Completion Button

/// Reusable button component for completion view with primary and secondary styles
struct CompletionButton: View {
    enum Style {
        case primary
        case secondary
    }

    let title: String
    let style: Style
    let action: () -> Void

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(title)
                .appFont(size: 14, weight: .medium)
                .foregroundColor(textColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return themeManager.currentTheme.colors.accentPrimary
        case .secondary:
            return themeManager.currentTheme.colors.backgroundTertiary
        }
    }

    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return themeManager.currentTheme.colors.textPrimary
        }
    }
}

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        CompletionButton(
            title: "Skip Break",
            style: .secondary,
            action: {}
        )

        CompletionButton(
            title: "Start Break",
            style: .primary,
            action: {}
        )
    }
    .padding()
    .background(Color(NSColor.windowBackgroundColor))
    .environmentObject(ThemeManager.shared)
    .environmentObject(FontManager.shared)
}
