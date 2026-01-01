//
//  WindowManager.swift
//  pomodomore
//
//  Created on 01/04/25.
//

import Cocoa
import SwiftUI
import Combine

/// Centralized window management for the Pomodoro timer
@MainActor
class WindowManager: ObservableObject {
    // MARK: - Singleton
    static let shared = WindowManager()

    // MARK: - Properties

    /// Shared timer view model
    let timerViewModel = TimerViewModel()

    /// The main timer window
    private(set) var timerWindow: TimerWindow?

    /// Always on top state
    @Published var alwaysOnTop: Bool {
        didSet {
            UserDefaults.standard.set(alwaysOnTop, forKey: "alwaysOnTop")
            updateWindowLevel()
        }
    }

    // MARK: - UserDefaults Keys
    private let windowXKey = "timerWindowX"
    private let windowYKey = "timerWindowY"
    private let alwaysOnTopKey = "alwaysOnTop"

    // MARK: - Initialization

    private init() {
        // Load always on top preference
        self.alwaysOnTop = UserDefaults.standard.bool(forKey: alwaysOnTopKey)
    }

    // MARK: - Public Methods

    /// Show or bring to front the timer window
    func showTimerWindow() {
        if timerWindow == nil {
            // Create window
            timerWindow = TimerWindow(windowManager: self)

            // Restore saved position or center
            restoreWindowPosition()

            // Set window level based on preference
            updateWindowLevel()

            // Save position when window moves
            setupPositionTracking()
        }

        timerWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Save current window position to UserDefaults
    func saveWindowPosition() {
        guard let window = timerWindow else { return }

        let frame = window.frame
        UserDefaults.standard.set(Double(frame.origin.x), forKey: windowXKey)
        UserDefaults.standard.set(Double(frame.origin.y), forKey: windowYKey)
    }

    // MARK: - Private Methods

    /// Restore window position from UserDefaults
    private func restoreWindowPosition() {
        guard let window = timerWindow else { return }

        // Check if we have saved position
        let savedX = UserDefaults.standard.double(forKey: windowXKey)
        let savedY = UserDefaults.standard.double(forKey: windowYKey)

        // Only restore if we have valid saved position
        if savedX != 0 || savedY != 0 {
            let origin = NSPoint(x: savedX, y: savedY)
            window.setFrameOrigin(origin)
        } else {
            // First launch - center window
            window.center()
        }
    }

    /// Update window level based on always on top preference
    private func updateWindowLevel() {
        guard let window = timerWindow else { return }
        window.level = alwaysOnTop ? .floating : .normal
    }

    /// Setup position tracking to save when window moves
    private func setupPositionTracking() {
        guard let window = timerWindow else { return }

        // Observer for window move
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.saveWindowPosition()
        }

        // Observer for window close (to save final position)
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.saveWindowPosition()
        }
    }
}
