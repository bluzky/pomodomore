//
//  SoundSettingsView.swift
//  pomodomore
//
//  Created on 01/02/26.
//

import SwiftUI
import UniformTypeIdentifiers

// MARK: - Sound Settings View

/// Sound and notification configuration settings
struct SoundSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var fontManager: FontManager
    private let soundManager = SoundManager.shared

    @State private var showingFilePicker = false

    private var tickSoundOptions: [String] {
        SoundManager.availableTickSounds
    }

    private var completionSoundOptions: [BundledSound] {
        SoundManager.availableCompletionSounds
    }

    @State private var ambientSoundList: [AmbientSoundItem] = []

    private var ambientSoundOptions: [AmbientSoundItem] {
        ambientSoundList
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                SettingsToggleRow(
                    label: "Completion Notifications",
                    isOn: $settingsManager.settings.sound.notificationsEnabled
                )

                // Completion Sound
                SettingsPickerRow(
                    label: "Completion Sound",
                    selection: $settingsManager.settings.sound.completionSound,
                    options: completionSoundOptions,
                    optionLabel: { $0.name }
                )
                .onChange(of: settingsManager.settings.sound.completionSound) { _, newValue in
                    soundManager.playCompletionSound(newValue)
                }

                // Tick Sound
                SettingsPickerRow(
                    label: "Tick Sound",
                    selection: $settingsManager.settings.sound.tickSound,
                    options: tickSoundOptions,
                    optionLabel: { $0 }
                )
                .onChange(of: settingsManager.settings.sound.tickSound) { _, newValue in
                    // Preview the selected tick sound (cancels any existing preview)
                    soundManager.previewTickSound(soundName: newValue)
                }

                // Ambient Sound
                SettingsPickerRow(
                    label: "Ambient Sound",
                    selection: $settingsManager.settings.sound.ambientSound,
                    options: ambientSoundOptions,
                    optionLabel: { $0.displayName }
                )

                HStack {
                    Spacer()
                    Button(action: { showingFilePicker = true }) {
                        Label("Add Sound", systemImage: "plus")
                            .appFont(size: 12)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(themeManager.currentTheme.colors.accentPrimary)
                }
                .padding(.horizontal, 16)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(themeManager.currentTheme.colors.backgroundPrimary)
        .onAppear { loadAmbientSounds() }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    _ = SoundLoader.importSound(from: url, to: "Sounds/ambient")
                    loadAmbientSounds()
                }
            case .failure:
                break
            }
        }
    }

    private func loadAmbientSounds() {
        ambientSoundList = SoundLoader.loadAmbientSounds()
    }
}

// MARK: - Preview

#Preview {
    SoundSettingsView()
        .frame(width: 560, height: 520)
        .environmentObject(SettingsManager.shared)
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
