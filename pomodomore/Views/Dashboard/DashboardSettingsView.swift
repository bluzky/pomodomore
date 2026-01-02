//
//  DashboardSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - Section Definition

/// Navigation sections in Dashboard + Settings window
enum DashboardSection: String, CaseIterable, Identifiable {
    case dashboard
    case general
    case pomodoro
    case sound
    case appearance

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .general: return "General"
        case .pomodoro: return "Pomodoro"
        case .sound: return "Sound"
        case .appearance: return "Appearance"
        }
    }

    var iconName: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .general: return "gearshape.fill"
        case .pomodoro: return "timer"
        case .sound: return "speaker.wave.2.fill"
        case .appearance: return "paintbrush.fill"
        }
    }

    var isSettingsSection: Bool {
        self != .dashboard
    }
}

// MARK: - Dashboard Settings View

/// Main window for Dashboard and Settings with sidebar navigation
struct DashboardSettingsView: View {
    @State private var selectedSection: DashboardSection = .dashboard
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: 0) {
            // Sidebar (200px)
            sidebar
                .frame(width: 200)
                .background(Color(NSColor.controlBackgroundColor))

            Divider()

            // Content Area (520px)
            VStack(spacing: 0) {
                contentArea
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Action buttons (only for settings sections)
                if selectedSection.isSettingsSection {
                    Divider()
                    actionButtons
                        .padding()
                }
            }
            .frame(width: 520)
        }
        .frame(width: 720, height: 520)
        .environmentObject(SettingsManager.shared)
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Dashboard section
            SidebarItem(
                section: .dashboard,
                isSelected: selectedSection == .dashboard
            ) {
                selectedSection = .dashboard
            }

            // Spacing
            Spacer()
                .frame(height: 16)

            // Settings header
            Text("Settings")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 4)

            // Settings sections
            ForEach([DashboardSection.general, .pomodoro, .sound, .appearance]) { section in
                SidebarItem(
                    section: section,
                    isSelected: selectedSection == section,
                    isDisabled: section == .appearance
                ) {
                    if section != .appearance {
                        selectedSection = section
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }

    // MARK: - Content Area

    @ViewBuilder
    private var contentArea: some View {
        switch selectedSection {
        case .dashboard:
            DashboardView()
        case .general:
            GeneralSettingsView()
        case .pomodoro:
            PomodoroSettingsView()
        case .sound:
            SoundSettingsView()
        case .appearance:
            VStack {
                Text("Appearance Settings (Week 4)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .frame(width: 520, alignment: .center)
            .frame(maxHeight: .infinity)
            .background(Color(NSColor.windowBackgroundColor))
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack {
            Spacer()

            Button("Cancel") {
                dismiss()
            }
            .keyboardShortcut(.cancelAction)

            Button("Save") {
                // Save will be implemented in Day 2
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
        }
    }
}

// MARK: - Sidebar Item

struct SidebarItem: View {
    let section: DashboardSection
    let isSelected: Bool
    var isDisabled: Bool = false
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Icon
                Image(systemName: section.iconName)
                    .font(.system(size: 15))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .frame(width: 18)

                // Section name
                Text(section.displayName)
                    .font(.system(size: 13))
                    .foregroundColor(isDisabled ? .secondary : .primary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
        )
        .onHover { hovering in
            if !isDisabled {
                isHovering = hovering
            }
        }
        .disabled(isDisabled)
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.gray.opacity(0.15)
        } else if isHovering {
            return Color.gray.opacity(0.08)
        } else {
            return Color.clear
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardSettingsView()
        .frame(width: 720, height: 520)
}
