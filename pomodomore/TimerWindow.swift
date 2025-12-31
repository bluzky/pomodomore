//
//  TimerWindow.swift
//  pomodomore
//
//  Created on 01/01/25.
//

import Cocoa
import SwiftUI

class TimerWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 200),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        // Window configuration
        self.title = "Pomodoro Timer"
        self.center()
        self.isReleasedWhenClosed = false // Don't destroy window when closed
        self.isMovableByWindowBackground = true // Allow dragging from content area

        // Host SwiftUI view
        let timerView = TimerView()
        self.contentView = NSHostingView(rootView: timerView)
    }

    // Override to prevent window from being destroyed on close
    override func close() {
        self.orderOut(nil) // Hide instead of close
    }
}
