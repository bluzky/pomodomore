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
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: {
            showPopover.toggle()
        }) {
            HStack(spacing: 4) {
                Circle()
                    .fill(selectedTag.color)
                    .frame(width: 6, height: 6)
                Text(selectedTag.name)
                    .appFont(size: 12, weight: .regular)
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
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
            .environmentObject(themeManager)
        }
    }
}

// MARK: - Tag Popover Item with Hover Effect

struct TagPopoverItem: View {
    let tag: SessionTag
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 6) {
                Circle()
                    .fill(tag.color)
                    .frame(width: 6, height: 6)
                Text(tag.name)
                    .appFont(size: 12)
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            isSelected ? themeManager.currentTheme.colors.accentPrimary.opacity(0.15) :
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

// MARK: - Glass Background View (macOS visual effect)
struct GlassBackgroundView: NSViewRepresentable {
    let cornerRadius: CGFloat
    let material: NSVisualEffectView.Material

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .behindWindow
        view.state = .active
        view.wantsLayer = true
        view.layer?.cornerRadius = cornerRadius
        view.layer?.masksToBounds = true
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.layer?.cornerRadius = cornerRadius
    }
}

// MARK: - Timer View
struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isHovered: Bool = false
    @State private var showAmbientPopover: Bool = false

    // Tiny mode: compact view when not hovered
    private var isTinyMode: Bool {
        settingsManager.settings.appearance.windowSize == .tiny
    }

    // Controls are always visible when idle/paused state, or on hover (only in normal mode)
    private var shouldShowControls: Bool {
        if isTinyMode {
            return false // Controls are shown in overlay in tiny mode
        }
        return viewModel.currentState == .idle || viewModel.currentState == .paused || isHovered
    }

    // Timer font size - tiny mode always 28, normal mode 36/42
    private var timerFontSize: CGFloat {
        if isTinyMode {
            return 28
        }
        return shouldShowControls ? 36 : 42
    }

    private var timerVerticalOffset: CGFloat {
        isTinyMode ? 0 : (shouldShowControls ? 0 : 10)
    }

    // View height - tiny mode always 50, normal mode 110
    private var viewHeight: CGFloat {
        isTinyMode ? 50 : 110
    }

    // View width - tiny mode always 120, normal mode 200
    private var viewWidth: CGFloat {
        isTinyMode ? 120 : 200
    }

    // Whether to show tag label and top controls
    private var shouldShowTagLabel: Bool {
        !isTinyMode
    }

    // VStack alignment - center in tiny mode, top otherwise
    private var vStackAlignment: Alignment {
        isTinyMode ? .center : .top
    }

    // Timer color based on state - uses theme accent color
    private var timerColor: Color {
        let theme = themeManager.currentTheme.colors
        switch viewModel.currentState {
        case .running:
            // Use accent color for active timer (more visually striking and theme-cohesive)
            return theme.accentPrimary
        case .paused:
            return theme.timerPaused
        case .idle, .completed:
            return theme.textPrimary
        }
    }

    // Show overlay controls on hover in tiny mode
    private var shouldShowOverlayControls: Bool {
        isTinyMode && isHovered
    }

    // Border radius - larger for tiny mode
    private var cornerRadius: CGFloat {
        isTinyMode ? 16 : 12
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
                        viewModel.toggleAllSounds()
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
                        .environmentObject(themeManager)
                    }
                }
                .padding(.trailing, 2)
            }
            .frame(height: 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 6)
            .opacity(shouldShowTagLabel && shouldShowControls ? 1 : 0)
            .animation(.easeOut(duration: 0.25), value: isHovered)
            .animation(.easeOut(duration: 0.25), value: viewModel.currentState)

            // Center content area
            VStack(spacing: 0) {
                // Tag label - 30px from top
                Group {
                    if shouldShowTagLabel {
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
                                        .appFont(size: 11, weight: .regular)
                                        .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                                }
                            }
                        } else {
                            // Break sessions: Show break type label
                            Text(viewModel.currentSessionType.displayName)
                                .appFont(size: 11, weight: .regular)
                                .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                        }
                    }
                }
                .frame(height: shouldShowTagLabel ? 16 : 0)
                .padding(.top, shouldShowTagLabel ? 20 : 0)
                .opacity(shouldShowTagLabel ? 1 : 0)
                .animation(.easeOut(duration: 0.2), value: shouldShowTagLabel)

                // Timer
                Text(viewModel.timeFormatted)
                    .font(FontManager.shared.swiftUIFont(size: timerFontSize, weight: .medium))
                    .foregroundColor(timerColor)
                    .offset(y: timerVerticalOffset)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .animation(.easeOut(duration: 0.25), value: timerFontSize)
                    .animation(.easeOut(duration: 0.25), value: isTinyMode)

                if !isTinyMode {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: vStackAlignment)

            // Bottom buttons - only visible in normal mode when controls should show
            if !isTinyMode {
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

                    // Stop button (when running, or on break when idle/paused)
                    if viewModel.currentState == .running || (viewModel.currentSessionType.isBreak && (viewModel.currentState == .idle || viewModel.currentState == .paused)) {
                        Button(action: { viewModel.skipBreak() }) {
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
                .animation(.easeOut(duration: 0.25), value: isHovered)
                .animation(.easeOut(duration: 0.25), value: viewModel.currentState)
            }

            // Overlay controls for tiny mode (on hover)
            if shouldShowOverlayControls {
                ZStack {
                    // Semi-transparent background (subtle)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color(nsColor: .windowBackgroundColor).opacity(0.90))

                    // Control buttons
                    HStack(spacing: 8) {
                        // Pause button (only when running)
                        if viewModel.currentState == .running {
                            Button(action: { viewModel.toggle() }) {
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 12))
                                    .frame(width: 26, height: 26)
                            }
                            .buttonStyle(HoverButtonStyle(hoverColor: .orange))
                        }

                        // Stop button (when running, or on break when idle/paused)
                        if viewModel.currentState == .running || (viewModel.currentSessionType.isBreak && (viewModel.currentState == .idle || viewModel.currentState == .paused)) {
                            Button(action: { viewModel.skipBreak() }) {
                                Image(systemName: "stop.fill")
                                    .font(.system(size: 12))
                                    .frame(width: 26, height: 26)
                            }
                            .buttonStyle(HoverButtonStyle(hoverColor: .red))
                        }

                        // Start button (when idle or paused)
                        if viewModel.currentState == .idle || viewModel.currentState == .paused {
                            Button(action: { viewModel.toggle() }) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 12))
                                    .frame(width: 26, height: 26)
                            }
                            .buttonStyle(HoverButtonStyle())
                        }

                        // Sound toggle button (only when not idle)
                        if viewModel.currentState != .idle {
                            Button(action: {
                                viewModel.toggleAllSounds()
                            }) {
                                Image(systemName: viewModel.isTickSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .font(.system(size: 12))
                                    .frame(width: 26, height: 26)
                            }
                            .buttonStyle(HoverButtonStyle())
                        }
                    }
                }
                .transition(.opacity)
                .animation(.easeOut(duration: 0.2), value: shouldShowOverlayControls)
            }
        }
        .frame(width: viewWidth, height: viewHeight)
        .animation(.easeOut(duration: 0.25), value: viewWidth)
        .animation(.easeOut(duration: 0.25), value: viewHeight)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(themeManager.currentTheme.colors.backgroundPrimary.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
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
    @EnvironmentObject var themeManager: ThemeManager

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
        .environmentObject(themeManager)
    }
}

// MARK: - Ambient Sound Popover Item with Hover Effect

struct AmbientSoundPopoverItem: View {
    let sound: AmbientSoundItem
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovered = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 6) {
                Image(systemName: sound.fileName.isEmpty ? "music.note.slash" : "music.note")
                    .font(.system(size: 10))
                    .foregroundColor(themeManager.currentTheme.colors.textSecondary)
                    .frame(width: 10)

                Text(sound.displayName)
                    .appFont(size: 12)
                    .foregroundColor(themeManager.currentTheme.colors.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            isSelected ? themeManager.currentTheme.colors.accentPrimary.opacity(0.15) :
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
        .environmentObject(ThemeManager.shared)
        .environmentObject(FontManager.shared)
}
