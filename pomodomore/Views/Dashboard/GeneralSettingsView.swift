//
//  GeneralSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - General Settings View

/// General application settings
struct GeneralSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Startup Section
                SettingsSectionHeader(title: "Startup")

                SettingsToggleRow(
                    label: "Start on login",
                    isOn: $settingsManager.settings.general.startOnLogin
                )
                .onChange(of: settingsManager.settings.general.startOnLogin) { _, newValue in
                    LoginItemsManager.shared.setLoginItem(enabled: newValue)
                }

                // About Section
                SettingsSectionHeader(title: "About")

                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Application", value: "PomodoMore")
                    InfoRow(label: "Version", value: "1.0")
                    InfoRow(label: "Description", value: "A beautiful Pomodoro timer for macOS")

                    Link("View on GitHub", destination: URL(string: "https://github.com/bluzky/pomodomore")!)
                        .font(.system(size: 13))
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)
        }
        .frame(width: 520, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)

            Text(value)
                .font(.system(size: 13))
        }
    }
}

// MARK: - Preview

#Preview {
    GeneralSettingsView()
        .frame(width: 560, height: 520)
}
