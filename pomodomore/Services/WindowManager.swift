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

    /// The dashboard + settings window
    private var settingsWindow: NSWindow?

    /// The completion window
    private(set) var completionWindow: CompletionWindow?

    /// Always on top state
    @Published var alwaysOnTop: Bool {
        didSet {
            UserDefaults.standard.set(alwaysOnTop, forKey: "alwaysOnTop")
            updateWindowLevel()
        }
    }

    /// Expanded (non-collapsed) position storage
    private var expandedPosition: NSPoint?

    /// Is window currently collapsed to edge
    private var isCollapsedToEdge = false

    /// Combine cancellables for subscriptions
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UserDefaults Keys
    private let windowXKey = "timerWindowX"
    private let windowYKey = "timerWindowY"
    private let alwaysOnTopKey = "alwaysOnTop"

    // MARK: - Initialization

    private init() {
        // Load always on top preference
        self.alwaysOnTop = UserDefaults.standard.bool(forKey: alwaysOnTopKey)

        // Observe completion state changes
        timerViewModel.$completionState
            .sink { [weak self] state in
                Task { @MainActor in
                    switch state {
                    case .hidden:
                        self?.hideCompletionWindow()
                    case .pomodoroComplete, .breakComplete, .breakRunning:
                        self?.showCompletionWindow()
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods

    /// Check if the timer window is currently visible
    var isTimerWindowVisible: Bool {
        guard let window = timerWindow else { return false }
        return window.isVisible
    }

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

        // Show window
        timerWindow?.makeKeyAndOrderFront(nil)

        // Behavior based on Always on Top setting:
        // - When checked: Keep window on top (floating level)
        // - When unchecked: Display and focus on timer
        if !alwaysOnTop {
            // Only activate app when not in always-on-top mode
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    /// Show or bring to front the dashboard + settings window
    func showDashboardSettingsWindow(selectedTab: DashboardSection = .dashboard) {
        // If window exists and section is different, recreate to update navigation
        if let existingWindow = settingsWindow {
            // Get current position before closing
            let currentPosition = existingWindow.frame.origin
            settingsWindow = nil
            existingWindow.close()

            // Create new window with updated section
            createDashboardWindow(selectedTab: selectedTab, position: currentPosition)
        } else {
            // Create new window centered
            createDashboardWindow(selectedTab: selectedTab, position: nil)
        }

        // Show window
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Create the dashboard settings window
    private func createDashboardWindow(selectedTab: DashboardSection, position: NSPoint?) {
        // Create the settings view with initial section
        let settingsView = DashboardSettingsView(selectedSection: selectedTab)
            .environmentObject(SettingsManager.shared)
            .environmentObject(ThemeManager.shared)
            .environmentObject(FontManager.shared)

        // Create hosting controller
        let hostingController = NSHostingController(rootView: settingsView)

        // Create window with unified toolbar style
        let window = NSWindow(contentViewController: hostingController)
        window.title = selectedTab.displayName
        window.styleMask = [.titled, .closable, .fullSizeContentView]
        window.titlebarAppearsTransparent = true
        window.setContentSize(NSSize(width: 720, height: 520))

        // Position window
        if let position = position {
            window.setFrameOrigin(position)
        } else {
            window.center()
        }

        // Disable zoom/maximize button and hide miniaturize button
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true

        // Prevent window from being resized
        window.minSize = NSSize(width: 720, height: 520)
        window.maxSize = NSSize(width: 720, height: 520)

        // Configure toolbar for unified appearance
        let toolbar = NSToolbar()
        window.toolbar = toolbar
        window.toolbarStyle = .unified

        settingsWindow = window

        // Apply theme appearance
        applyThemeAppearance(to: window)
    }

    /// Apply current theme's light/dark appearance to a window
    private func applyThemeAppearance(to window: NSWindow) {
        if ThemeManager.shared.currentTheme.isDark {
            window.appearance = NSAppearance(named: .darkAqua)
        } else {
            window.appearance = NSAppearance(named: .aqua)
        }
    }

    /// Save current window position to UserDefaults
    func saveWindowPosition() {
        guard let window = timerWindow else { return }

        let frame = window.frame
        UserDefaults.standard.set(Double(frame.origin.x), forKey: windowXKey)
        UserDefaults.standard.set(Double(frame.origin.y), forKey: windowYKey)
    }

    /// Show completion window centered on screen
    func showCompletionWindow() {
        print("📍 [WindowManager] showCompletionWindow() called")
        // Hide timer window when showing completion
        timerWindow?.orderOut(nil)

        // Create window if needed
        if completionWindow == nil {
            print("📍 [WindowManager] Creating new CompletionWindow")
            completionWindow = CompletionWindow(windowManager: self)
        }

        // Show centered (position set in window init)
        completionWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        print("📍 [WindowManager] CompletionWindow shown")
    }

    /// Hide completion window and restore timer if needed
    func hideCompletionWindow() {
        completionWindow?.orderOut(nil)

        // Show timer window if there's an active session
        if timerViewModel.currentState != .idle {
            showTimerWindow()
        }
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
            // First launch - position at top center
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let windowFrame = window.frame
                let x = screenFrame.origin.x + (screenFrame.width - windowFrame.width) / 2
                let y = screenFrame.origin.y + screenFrame.height - windowFrame.height - 10
                window.setFrameOrigin(NSPoint(x: x, y: y))
            } else {
                // Fallback to center if no screen found
                window.center()
            }
        }
    }

    /// Update window level based on always on top preference
    private func updateWindowLevel() {
        guard let window = timerWindow else { return }
        window.level = alwaysOnTop ? .popUpMenu : .normal
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
            guard let self else { return }
            Task { @MainActor in
                self.saveWindowPosition()
            }
        }

        // Observer for window close (to save final position)
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.saveWindowPosition()
            }
        }
    }
}
