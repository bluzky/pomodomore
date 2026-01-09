//
//  AppDelegate.swift
//  pomodomore
//
//  Created on 12/31/25.
//

import Cocoa
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var timerStatusMenuItem: NSMenuItem?
    var stopMenuItem: NSMenuItem?
    let windowManager = WindowManager.shared
    private var cancellables = Set<AnyCancellable>()
    private var appIcon: NSImage?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        // Load app icon
        appIcon = NSImage(imageLiteralResourceName: "AppIcon")

        if let button = statusItem?.button {
            button.image = appIcon
            // Adjust image position to align properly in status bar
            button.imagePosition = .imageLeft
            // Scale image appropriately for status bar (18x18 is standard)
            button.image?.size = NSSize(width: 18, height: 18)
        }

        // Create menu
        let menu = NSMenu()

        // Add Show Timer menu item
        let showTimerItem = createMenuItem(title: "Show Timer", action: #selector(showTimerWindow), keyEquivalent: "t", icon: "timer")
        menu.addItem(showTimerItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Start/Pause menu item
        let startPauseItem = createMenuItem(title: "Start", action: #selector(toggleTimer), keyEquivalent: "s", icon: "play.fill")
        menu.addItem(startPauseItem)
        timerStatusMenuItem = startPauseItem // Reuse this for Start/Pause text

        // Add Stop menu item (no key equivalent to avoid confusion)
        let stopItem = createMenuItem(title: "Stop", action: #selector(stopTimer), keyEquivalent: "", icon: "stop.fill")
        stopItem.isHidden = true // Hidden by default when idle
        menu.addItem(stopItem)
        stopMenuItem = stopItem

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Dashboard menu item
        let dashboardItem = createMenuItem(title: "Dashboard", action: #selector(showDashboard), keyEquivalent: ",", icon: "square.grid.2x2")
        menu.addItem(dashboardItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Always on Top toggle
        let alwaysOnTopItem = createMenuItem(title: "Always on Top", action: #selector(toggleAlwaysOnTop), keyEquivalent: "", icon: nil)
        if windowManager.alwaysOnTop {
            alwaysOnTopItem.image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
        }
        menu.addItem(alwaysOnTopItem)

        // Add Settings menu item
        let settingsItem = createMenuItem(title: "Settings", action: #selector(showSettings), keyEquivalent: "", icon: "gearshape")
        menu.addItem(settingsItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Quit menu item
        let quitItem = createMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q", icon: "power")
        menu.addItem(quitItem)

        // Assign menu to status item
        statusItem?.menu = menu

        // Setup observers for timer state changes
        setupTimerObservers()

        // Setup observer for font changes
        setupFontObserver()
    }

    // MARK: - Menu Helper

    /// Create a menu item with custom font
    private func createMenuItem(title: String, action: Selector, keyEquivalent: String, icon: String?) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        if let icon = icon {
            item.image = NSImage(systemSymbolName: icon, accessibilityDescription: nil)
        }
        item.attributedTitle = createAttributedTitle(title)
        return item
    }

    /// Create attributed string with custom font for menu item
    private func createAttributedTitle(_ title: String) -> NSAttributedString {
        let fontName = FontManager.shared.currentFontName
        let fontSize: CGFloat = 13
        let font = NSFont(name: fontName, size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.labelColor
        ]

        return NSAttributedString(string: title, attributes: attributes)
    }

    /// Update all menu item titles with new font
    private func updateMenuFont() {
        if let menu = statusItem?.menu {
            for item in menu.items {
                // Skip separators (they have empty title)
                if !item.title.isEmpty {
                    item.attributedTitle = createAttributedTitle(item.title)
                }
            }
        }
    }

    /// Setup observer for font changes
    private func setupFontObserver() {
        FontManager.shared.$currentFontName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenuFont()
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc func showTimerWindow() {
        windowManager.showTimerWindow()
    }

    @objc func toggleTimer() {
        // Show timer window when starting from menubar
        if windowManager.timerViewModel.currentState == .idle {
            windowManager.showTimerWindow()
        }
        windowManager.timerViewModel.toggle()
    }

    @objc func stopTimer() {
        windowManager.timerViewModel.stop()
    }

    @objc func toggleAlwaysOnTop() {
        windowManager.alwaysOnTop.toggle()

        // Update menu item icon
        if let menu = statusItem?.menu {
            for item in menu.items {
                if item.title == "Always on Top" {
                    item.image = windowManager.alwaysOnTop
                        ? NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
                        : nil
                }
            }
        }
    }

    @objc func showDashboard() {
        windowManager.showDashboardSettingsWindow()
    }

    @objc func showSettings() {
        windowManager.showDashboardSettingsWindow(selectedTab: .general)
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep app running even when all windows are closed
        return false
    }

    // MARK: - Timer Status Updates

    private func setupTimerObservers() {
        // Observe time remaining changes (for countdown updates)
        windowManager.timerViewModel.$timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenubarStatus()
            }
            .store(in: &cancellables)

        // Observe timer state changes (for Start/Pause button and countdown visibility)
        windowManager.timerViewModel.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenubarStatus()
            }
            .store(in: &cancellables)
    }

    private func updateMenubarStatus() {
        let viewModel = windowManager.timerViewModel
        let timeText = viewModel.timeFormatted

        // Update menubar button (shows time with icon)
        // Show time when running or paused, just icon when idle or completed
        if let button = statusItem?.button {
            button.image = appIcon
            button.image?.size = NSSize(width: 18, height: 18)

            switch viewModel.currentState {
            case .running, .paused:
                button.title = timeText
            case .idle, .completed:
                button.title = ""
            }
        }

        // Update Start/Pause menu item text
        timerStatusMenuItem?.title = viewModel.primaryActionTitle

        // Show/hide Stop menu item based on state
        stopMenuItem?.isHidden = viewModel.currentState == .idle
    }
}
