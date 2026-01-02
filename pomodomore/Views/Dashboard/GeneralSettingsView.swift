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
            VStack(alignment: .leading, spacing: 24) {
                // Startup Section
                startupSection

                // About Section
                aboutSection

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .frame(width: 520, alignment: .leading)
        .frame(maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Startup Section

    private var startupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Startup")
                .font(.system(size: 14, weight: .semibold))

            Toggle("Start on login", isOn: $settingsManager.settings.general.startOnLogin)
                .toggleStyle(.switch)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.system(size: 14, weight: .semibold))

            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "Application", value: "PomodoMore")
                InfoRow(label: "Version", value: "1.0")
                InfoRow(label: "Description", value: "A beautiful Pomodoro timer for macOS")

                Link("View on GitHub", destination: URL(string: "https://github.com/bluzky/pomodomore")!)
                    .font(.system(size: 13))
                    .padding(.top, 4)
            }
        }
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
