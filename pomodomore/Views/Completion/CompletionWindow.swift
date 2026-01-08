//
//  CompletionWindow.swift
//  pomodomore
//
//  Created on January 8, 2026.
//  Week 5, Day 6: Session completion floating view
//

import Cocoa
import SwiftUI

// MARK: - Completion Window

/// Floating window for session completion with celebration and manual controls
class CompletionWindow: NSWindow {
    init(windowManager: WindowManager) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 180),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        // Window configuration
        self.level = .floating // Always on top
        self.isReleasedWhenClosed = false // Don't destroy window when closed
        self.isMovableByWindowBackground = false // Not draggable (stays centered)
        self.backgroundColor = .clear // Transparent background
        self.isOpaque = false // Allow transparency
        self.hasShadow = true // Shadow for depth

        // Center on screen
        self.center()

        // Host SwiftUI CompletionView
        let completionView = CompletionView(viewModel: windowManager.timerViewModel)
            .environmentObject(SettingsManager.shared)
            .environmentObject(ThemeManager.shared)
            .environmentObject(FontManager.shared)

        let hostingView = NSHostingView(rootView: completionView)
        self.contentView = hostingView

        // Apply theme appearance
        if ThemeManager.shared.currentTheme.isDark {
            self.appearance = NSAppearance(named: .darkAqua)
        } else {
            self.appearance = NSAppearance(named: .aqua)
        }
    }

    // Allow borderless window to become key window (receive keyboard focus)
    override var canBecomeKey: Bool {
        return true
    }

    override func close() {
        // Hide instead of destroy
        self.orderOut(nil)
    }
}
