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
    case sound
    case about
    case appearance

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .general: return "General"
        case .sound: return "Sound"
        case .about: return "About"
        case .appearance: return "Appearance"
        }
    }

    var iconName: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .general: return "gearshape.fill"
        case .sound: return "speaker.wave.2.fill"
        case .about: return "info.circle.fill"
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
    @State private var selectedSection: DashboardSection

    init(selectedSection: DashboardSection = .dashboard) {
        _selectedSection = State(initialValue: selectedSection)
    }

    var body: some View {
        NavigationSplitView {
            // Sidebar
            sidebar
                .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 220)
        } detail: {
            // Content Area
            contentArea
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

                 NavigationLink(value: DashboardSection.about) {
                     Label {
                         Text("About")
                     } icon: {
                         Image(systemName: "info.circle.fill")
                     }
                 }
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Content Area

    @ViewBuilder
    private var contentArea: some View {
        switch selectedSection {
        case .dashboard:
            DashboardView()
        case .general:
            GeneralSettingsView()
        case .sound:
            SoundSettingsView()
        case .about:
            AboutView()
        case .appearance:
            AppearanceSettingsView()
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardSettingsView(selectedSection: .dashboard)
        .frame(width: 720, height: 520)
}
