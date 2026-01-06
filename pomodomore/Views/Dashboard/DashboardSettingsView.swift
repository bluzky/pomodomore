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
    @EnvironmentObject var themeManager: ThemeManager

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
        .environmentObject(ThemeManager.shared)
        .tint(themeManager.currentTheme.colors.accentPrimary)
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        List {
            // Dashboard section
            Section {
                sidebarItem(section: .dashboard)
            }

            // Settings sections
            Section("Settings") {
                sidebarItem(section: .general)
                sidebarItem(section: .sound)
                sidebarItem(section: .appearance)
                sidebarItem(section: .about)
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .background(themeManager.currentTheme.colors.sidebarBackground)
    }

    // MARK: - Sidebar Item Helper

    @ViewBuilder
    private func sidebarItem(section: DashboardSection) -> some View {
        Button(action: {
            selectedSection = section
        }) {
            HStack(spacing: 12) {
                Image(systemName: section.iconName)
                    .foregroundStyle(selectedSection == section ? themeManager.currentTheme.colors.accentPrimary : themeManager.currentTheme.colors.textSecondary)
                    .frame(width: 20)

                Text(section.displayName)
                    .foregroundStyle(selectedSection == section ? themeManager.currentTheme.colors.accentPrimary : themeManager.currentTheme.colors.textSecondary)

                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selectedSection == section ? themeManager.currentTheme.colors.sidebarSelected : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
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
        .environmentObject(ThemeManager.shared)
}
