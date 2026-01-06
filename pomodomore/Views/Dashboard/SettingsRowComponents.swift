//
//  SettingsRowComponents.swift
//  pomodomore
//
//  Created on 01/03/26.
//

import SwiftUI

// MARK: - Settings Navigation Row

/// Navigation row with icon, label, and chevron (leads to detail view)
struct SettingsNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    @State private var isHovering = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon with colored background
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(iconColor)
                        .frame(width: 32, height: 32)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }

                // Title
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovering ? themeManager.currentTheme.colors.backgroundTertiary : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

// MARK: - Settings Picker Row

/// Row with label and picker/dropdown
struct SettingsPickerRow<T: Hashable>: View {
    let label: String
    @Binding var selection: T
    let options: [T]
    let optionLabel: (T) -> String
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)

            Spacer()

            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(optionLabel(option)).tag(option)
                }
            }
            .pickerStyle(.menu)
            .fixedSize()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Settings Toggle Row

/// Row with label and toggle switch
struct SettingsToggleRow: View {
    let label: String
    @Binding var isOn: Bool
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .controlSize(.small)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Settings Section Header

/// Section header with title
struct SettingsSectionHeader: View {
    let title: String
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(themeManager.currentTheme.colors.textPrimary)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Settings Stepper Row

/// Row with label and stepper control
struct SettingsStepperRow: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let valueFormatter: (Int) -> String
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(themeManager.currentTheme.colors.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                Text(valueFormatter(value))
                    .font(.system(size: 13))
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .frame(minWidth: 60, alignment: .trailing)

                Stepper("", value: $value, in: range)
                    .labelsHidden()
                    .fixedSize()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 0) {
        SettingsNavigationRow(
            icon: "display",
            iconColor: .blue,
            title: "Display",
            action: {}
        )

        SettingsNavigationRow(
            icon: "textformat.abc",
            iconColor: .cyan,
            title: "Completion",
            action: {}
        )

        Divider()
            .padding(.vertical, 8)

        SettingsPickerRow(
            label: "Default text encoding",
            selection: .constant("UTF-8"),
            options: ["UTF-8", "UTF-16", "ASCII"],
            optionLabel: { $0 }
        )

        SettingsToggleRow(
            label: "Automatically trim trailing whitespace",
            isOn: .constant(true)
        )

        SettingsSectionHeader(title: "When Editing")

        SettingsToggleRow(
            label: "Trim whitespace-only lines",
            isOn: .constant(false)
        )
    }
    .frame(width: 520)
    .background(Color(NSColor.windowBackgroundColor))
    .environmentObject(ThemeManager.shared)
}
