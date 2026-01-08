//
//  CompletionView.swift
//  pomodomore
//
//  Created on January 8, 2026.
//  Week 5, Day 6: Session completion floating view
//

import SwiftUI

// MARK: - Completion View

/// Main completion view UI with celebration messages and action buttons
struct CompletionView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager

    var body: some View {
        VStack(spacing: 12) {
            // Top: Celebration message with emoji
            celebrationHeader

            // Middle: Context-specific content
            contentSection

            // Bottom: Action buttons
            actionButtons
        }
        .padding(30)
        .frame(width: 400, height: 180)
        .background(backgroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Sub-views

    private var celebrationHeader: some View {
        Group {
            if case .breakRunning = viewModel.completionState {
                // For break running: combine emoji and message in single line
                Text("\(celebrationEmoji) \(celebrationMessage)")
                    .appFont(size: 14, weight: .semibold)
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            } else {
                // For other states: separate rows
                VStack(spacing: 12) {
                    Text(celebrationEmoji)
                        .font(.system(size: 48))

                    Text(celebrationMessage)
                        .appFont(size: 14, weight: .semibold)
                        .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                }
            }
        }
    }

    private var contentSection: some View {
        Group {
            switch viewModel.completionState {
            case .pomodoroComplete:
                pomodoroCompleteContent
            case .breakComplete:
                breakCompleteContent
            case .breakRunning(let timeRemaining):
                breakRunningContent(timeRemaining)
            case .hidden:
                EmptyView()
            }
        }
    }

    private var pomodoroCompleteContent: some View {
        EmptyView()
    }

    private var breakCompleteContent: some View {
        EmptyView()
    }

    private func breakRunningContent(_ timeRemaining: Int) -> some View {
        // Show countdown timer
        Text(formatTime(timeRemaining))
            .font(fontManager.swiftUIFont(size: 42, weight: .medium))
            .foregroundColor(themeManager.currentTheme.colors.accentPrimary)
    }

    private var actionButtons: some View {
        HStack(spacing: 20) {
            switch viewModel.completionState {
            case .pomodoroComplete:
                // Skip button (secondary - subtle)
                iconButton(icon: "forward.fill", isPrimary: false, action: { viewModel.skipBreakFromCompletion() })

                // Start Break button (primary - prominent)
                iconButton(icon: "play.fill", isPrimary: true, action: { viewModel.startBreakFromCompletion() })

            case .breakComplete:
                // Start Next Pomodoro button (single button - centered)
                Spacer()
                iconButton(icon: "play.fill", isPrimary: true, action: { viewModel.startNextPomodoroFromCompletion() })
                Spacer()

            case .breakRunning:
                // Skip Break button (centered)
                Spacer()
                iconButton(icon: "forward.fill", isPrimary: false, action: { viewModel.skipBreakFromCompletion() })
                Spacer()

            case .hidden:
                EmptyView()
            }
        }
    }

    private func iconButton(icon: String, isPrimary: Bool, action: @escaping () -> Void) -> some View {
        IconButtonView(icon: icon, isPrimary: isPrimary, action: action)
            .environmentObject(themeManager)
    }

    // MARK: - Styling

    private var backgroundStyle: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(themeManager.currentTheme.colors.backgroundPrimary.opacity(0.85))
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }

    // MARK: - Helper Properties

    private var celebrationEmoji: String {
        switch viewModel.completionState {
        case .pomodoroComplete:
            return "🎉"
        case .breakComplete:
            return "✅"
        case .breakRunning:
            return "☕"
        case .hidden:
            return ""
        }
    }

    private var celebrationMessage: String {
        switch viewModel.completionState {
        case .pomodoroComplete:
            return "Great! Session Complete"
        case .breakComplete:
            return "Break Complete"
        case .breakRunning:
            return "Break Time"
        case .hidden:
            return ""
        }
    }

    private var nextBreakType: String {
        viewModel.completedSessions == 4 ? "Time for a long break!" : "Time for a short break"
    }

    // MARK: - Helper Methods

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

// MARK: - Icon Button with Hover Effect

struct IconButtonView: View {
    let icon: String
    let isPrimary: Bool
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isPrimary ?
                    themeManager.currentTheme.colors.accentPrimary :
                    themeManager.currentTheme.colors.textPrimary.opacity(0.5))
                .frame(width: 36, height: 36)
                .background(isHovered ?
                    themeManager.currentTheme.colors.accentPrimary.opacity(0.2) :
                    themeManager.currentTheme.colors.backgroundSecondary)
                .clipShape(Circle())
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Preview

#Preview {
    CompletionView(viewModel: TimerViewModel())
        .environmentObject(SettingsManager.shared)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
