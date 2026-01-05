//
//  AboutView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI

// MARK: - About View

/// About application information
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // About Section
                SettingsSectionHeader(title: "About")

                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Application", value: "Pomo Domo")
                    InfoRow(label: "Version", value: "1.0")
                    InfoRow(label: "Description", value: "A beautiful focus timer for macOS")

                    Link("View on GitHub", destination: URL(string: "https://github.com/bluzky/pomodomore")!)
                        .font(.system(size: 13))
                        .padding(.top, 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    AboutView()
        .frame(width: 560, height: 520)
}
