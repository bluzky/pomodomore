//
//  DashboardSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - Section Definition

/// Navigation sections in Dashboard + Settings window
enum DashboardSection: String, CaseIterable, Identifiable, Hashable {
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
        NavigationSplitView {
            // Sidebar
            sidebar
                .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 220)
        } detail: {
            // Content Area
            VStack(spacing: 0) {
                contentArea
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Action buttons (only for settings sections)
                if selectedSection.isSettingsSection {
                    Divider()
                    actionButtons
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
            }
            .navigationTitle(selectedSection.displayName)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(width: 720, height: 520)
        .environmentObject(SettingsManager.shared)
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        List(selection: $selectedSection) {
            // Dashboard section
            Section {
                NavigationLink(value: DashboardSection.dashboard) {
                    Label {
                        Text("Dashboard")
                    } icon: {
                        Image(systemName: "chart.bar.fill")
                    }
                }
            }

            // Settings sections
            Section("Settings") {
                NavigationLink(value: DashboardSection.general) {
                    Label {
                        Text("General")
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }

                NavigationLink(value: DashboardSection.pomodoro) {
                    Label {
                        Text("Pomodoro")
                    } icon: {
                        Image(systemName: "timer")
                    }
                }

                NavigationLink(value: DashboardSection.sound) {
                    Label {
                        Text("Sound")
                    } icon: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                }

                NavigationLink(value: DashboardSection.appearance) {
                    Label {
                        Text("Appearance")
                    } icon: {
                        Image(systemName: "paintbrush.fill")
                    }
                }
                .disabled(true)
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .background(Color.orange.opacity(0.3))
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

            Button("Close") {
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardSettingsView()
        .frame(width: 720, height: 520)
}
