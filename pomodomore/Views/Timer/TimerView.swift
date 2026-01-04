//
//  TimerView.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import SwiftUI

// MARK: - Custom Traffic Light Button
struct TrafficLightButton: View {
    let type: ButtonType
    let action: () -> Void

    enum ButtonType {
        case close
        case minimize
        case maximize
    }

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(type.backgroundColor(isHovered: isHovered))
                    .frame(width: 12, height: 12)

                if isHovered {
                    Image(systemName: type.symbol)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(type.iconColor)
                }
            }
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

extension TrafficLightButton.ButtonType {
    func backgroundColor(isHovered: Bool) -> Color {
        switch self {
        case .close:
            return isHovered ? Color(red: 1.0, green: 0.37, blue: 0.34) : Color.primary.opacity(0.3) // Red on hover, gray default
        case .minimize:
            return Color(red: 1.0, green: 0.77, blue: 0.22) // #FFBD2E
        case .maximize:
            return Color(red: 0.35, green: 0.83, blue: 0.44) // #28C940
        }
    }
    
    var iconColor: Color {
        switch self {
        case .close: return Color(red: 0.6, green: 0.0, blue: 0.0) // Dark red
        case .minimize: return .white
        case .maximize: return .white
        }
    }

    var symbol: String {
        switch self {
        case .close: return "xmark"
        case .minimize: return "minus"
        case .maximize: return "plus"
        }
    }
}

// MARK: - Interactive Button Style Base
private struct InteractiveButtonContent: View {
    let configuration: ButtonStyle.Configuration
    let pressScale: CGFloat
    @State private var isHovered = false
    let content: (_ isPressed: Bool, _ isHovered: Bool) -> AnyView

    var body: some View {
        content(configuration.isPressed, isHovered)
            .scaleEffect(configuration.isPressed ? pressScale : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.15), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Sound Button Style
struct SoundButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        InteractiveButtonContent(
            configuration: configuration,
            pressScale: 0.9
        ) { isPressed, isHovered in
            AnyView(
                configuration.label
                    .foregroundColor(iconColor(isPressed: isPressed, isHovered: isHovered))
            )
        }
    }

    private func iconColor(isPressed: Bool, isHovered: Bool) -> Color {
        if isPressed {
            return .primary.opacity(0.9)
        } else if isHovered {
            return .primary.opacity(0.8)
        } else {
            return .primary.opacity(0.6)
        }
    }
}

// MARK: - Custom Tag Select Button
struct TagSelectButton: View {
    @Binding var selectedTag: SessionTag
    @State private var showPopover = false

    var body: some View {
        Button(action: {
            showPopover.toggle()
        }) {
            HStack(spacing: 4) {
                Circle()
                    .fill(selectedTag.color)
                    .frame(width: 6, height: 6)
                Text(selectedTag.name)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(SessionTag.predefinedTags) { tag in
                    TagPopoverItem(
                        tag: tag,
                        isSelected: selectedTag.id == tag.id,
                        onSelect: {
                            selectedTag = tag
                            showPopover = false
                        }
                    )
                }
            }
            .frame(width: 120)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
        }
    }
}

// MARK: - Tag Popover Item with Hover Effect

struct TagPopoverItem: View {
    let tag: SessionTag
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 6) {
                Circle()
                    .fill(tag.color)
                    .frame(width: 6, height: 6)
                Text(tag.name)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            isSelected ? Color.accentColor.opacity(0.15) :
            isHovered ? Color.primary.opacity(0.06) :
            Color.clear
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Hover Button Style
struct HoverButtonStyle: ButtonStyle {
    let hoverColor: Color?

    init(hoverColor: Color? = nil) {
        self.hoverColor = hoverColor
    }

    func makeBody(configuration: Configuration) -> some View {
        InteractiveButtonContent(
            configuration: configuration,
            pressScale: 0.95
        ) { isPressed, isHovered in
            AnyView(
                configuration.label
                    .background(
                        Circle()
                            .fill(backgroundColor(isPressed: isPressed, isHovered: isHovered))
                    )
                    .foregroundStyle(iconColor(isPressed: isPressed, isHovered: isHovered))
            )
        }
    }

    private func backgroundColor(isPressed: Bool, isHovered: Bool) -> Color {
        if isPressed {
            return Color.primary.opacity(0.15)
        } else if isHovered {
            return Color.primary.opacity(0.12)
        } else {
            return Color.primary.opacity(0.08)
        }
    }

    private func iconColor(isPressed: Bool, isHovered: Bool) -> Color {
        if let hoverColor = hoverColor, (isHovered || isPressed) {
            return hoverColor
        } else {
            return .primary
        }
    }
}

// MARK: - Timer View
struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject var settingsManager: SettingsManager

    @State private var isHovered: Bool = false
    @State private var showAmbientPopover: Bool = false

    // Controls are always visible when idle/paused state, or on hover
    private var shouldShowControls: Bool {
        viewModel.currentState == .idle || viewModel.currentState == .paused || isHovered
    }

    // Timer scales up and repositions when controls are hidden
    private var timerFontSize: CGFloat {
        shouldShowControls ? 36 : 42
    }

    private var timerVerticalOffset: CGFloat {
        shouldShowControls ? 0 : 10
    }

    var body: some View {
        ZStack {
            // Top controls row - absolute positioning
            HStack(spacing: 0) {
                // Close button - 6px from left (traffic light style)
                TrafficLightButton(type: .close) {
                    closeWindow()
                }
                .padding(.leading, 6)

                Spacer()

                // Sound controls - right side
                HStack(spacing: 4) {
                    // Sound toggle - 160px from left (or 22px from right)
                    Button(action: {
                        viewModel.toggleTickSound()
                    }) {
                        Image(systemName: viewModel.isTickSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(.system(size: 10))
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(SoundButtonStyle())

                    // Music toggle - 182px from left (or 2px from right)
                    Button(action: {
                        showAmbientPopover.toggle()
                    }) {
                        Image(systemName: settingsManager.settings.sound.ambientSound == .none ? "music.note.slash" : "music.note")
                            .font(.system(size: 10))
                            .frame(width: 16, height: 16)
                    }
                    .buttonStyle(SoundButtonStyle())
                    .popover(isPresented: $showAmbientPopover, arrowEdge: .bottom) {
                        AmbientSoundPopoverView(
                            selectedSound: $settingsManager.settings.sound.ambientSound,
                            viewModel: viewModel,
                            showPopover: $showAmbientPopover
                        )
                    }
                }
                .padding(.trailing, 2)
            }
            .frame(height: 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 6)
            .opacity(shouldShowControls ? 1 : 0)
            .animation(.easeOut(duration: 0.25), value: shouldShowControls)

            // Center content area
            VStack(spacing: 0) {
                // Tag label - 30px from top
                Group {
                    if viewModel.currentSessionType == .pomodoro {
                        // Pomodoro: Show custom tag select button (idle) or display tag (active/paused)
                        if viewModel.currentState == .idle {
                            TagSelectButton(selectedTag: $viewModel.selectedTag)
                        } else {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(viewModel.selectedTag.color)
                                    .frame(width: 6, height: 6)
                                Text(viewModel.selectedTag.name)
                                    .font(.system(size: 11, weight: .regular))
                                    .foregroundColor(.primary)
                            }
                        }
                    } else {
                        // Break sessions: Show break type label
                        Text(viewModel.currentSessionType.displayName)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.primary)
                    }
                }
                .frame(height: 16)
                .padding(.top, 20)

                // Timer - 50px from top when controls visible
                Text(viewModel.timeFormatted)
                    .font(.system(size: timerFontSize, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary)
                    .offset(y: timerVerticalOffset)
                    .animation(.easeOut(duration: 0.25), value: shouldShowControls)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            // Bottom buttons - only visible when timer is running (and controls should show)
            HStack(spacing: 8) {
                // Pause button (only when running)
                if viewModel.currentState == .running {
                    Button(action: { viewModel.toggle() }) {
                        Image(systemName: "pause.fill")
                            .font(.system(size: 10))
                            .frame(width: 22, height: 22)
                    }
                    .buttonStyle(HoverButtonStyle(hoverColor: .orange))
                }

                // Stop button (only when running)
                if viewModel.currentState == .running {
                    Button(action: { viewModel.stop() }) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 10))
                            .frame(width: 22, height: 22)
                    }
                    .buttonStyle(HoverButtonStyle(hoverColor: .red))
                }

                // Start button (when idle or paused)
                if viewModel.currentState == .idle || viewModel.currentState == .paused {
                    Button(action: { viewModel.toggle() }) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 10))
                            .frame(width: 22, height: 22)
                    }
                    .buttonStyle(HoverButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 6)
            .opacity(shouldShowControls ? 1 : 0)
            .animation(.easeOut(duration: 0.25), value: shouldShowControls)
        }
        .frame(width: 200, height: 110)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: .windowBackgroundColor).opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 0.5)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private func closeWindow() {
        if let window = NSApplication.shared.windows.first(where: { $0 is TimerWindow }) {
            window.close()
        }
    }
}

// MARK: - Ambient Sound Popover View

struct AmbientSoundPopoverView: View {
    @Binding var selectedSound: AmbientSoundItem
    @ObservedObject var viewModel: TimerViewModel
    @Binding var showPopover: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(SoundManager.availableAmbientSounds) { sound in
                AmbientSoundPopoverItem(
                    sound: sound,
                    isSelected: selectedSound.id == sound.id,
                    onSelect: {
                        selectedSound = sound
                        showPopover = false

                        // If Pomodoro is running, replace the current ambient sound immediately
                        if viewModel.currentState == .running && viewModel.currentSessionType == .pomodoro {
                            SoundManager.shared.stopAmbient()
                            if sound.fileName.isEmpty == false {
                                SoundManager.shared.startAmbient(sound)
                            }
                        }
                    }
                )
            }
        }
        .frame(width: 140)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}

// MARK: - Ambient Sound Popover Item with Hover Effect

struct AmbientSoundPopoverItem: View {
    let sound: AmbientSoundItem
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 6) {
                Image(systemName: sound.fileName.isEmpty ? "music.note.slash" : "music.note")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .frame(width: 10)

                Text(sound.displayName)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            isSelected ? Color.accentColor.opacity(0.15) :
            isHovered ? Color.primary.opacity(0.06) :
            Color.clear
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// Preview for development
#Preview {
    TimerView(viewModel: WindowManager.shared.timerViewModel)
        .frame(width: 200, height: 110)
}
