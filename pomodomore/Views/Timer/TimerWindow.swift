//
//  TimerWindow.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import Cocoa
import SwiftUI

class TimerWindow: NSWindow {
    init(windowManager: WindowManager) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 110),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        // Window configuration
        self.level = .floating // Keep window above others
        self.center()
        self.isReleasedWhenClosed = false // Don't destroy window when closed
        self.isMovableByWindowBackground = true // Allow dragging from content area
        self.backgroundColor = .clear // Transparent background
        self.isOpaque = false // Allow transparency
        self.hasShadow = true // Keep shadow for depth

        // Host SwiftUI view with shared timer view model and environment objects
        let timerView = TimerView(viewModel: windowManager.timerViewModel)
            .environmentObject(SettingsManager.shared)
            .environmentObject(ThemeManager.shared)
        let hostingView = NSHostingView(rootView: timerView)

        // Disable clipping to allow dropdown and popups to overflow
        hostingView.wantsLayer = true
        hostingView.layer?.masksToBounds = false

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
    
    // Override to prevent window from being destroyed on close
    override func close() {
        self.orderOut(nil) // Hide instead of close
    }
}
