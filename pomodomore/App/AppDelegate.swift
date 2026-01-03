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
        let showTimerItem = NSMenuItem(
            title: "Show Timer",
            action: #selector(showTimerWindow),
            keyEquivalent: "t"
        )
        menu.addItem(showTimerItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Start/Pause menu item
        let startPauseItem = NSMenuItem(
            title: "Start",
            action: #selector(toggleTimer),
            keyEquivalent: "s"
        )
        menu.addItem(startPauseItem)
        timerStatusMenuItem = startPauseItem // Reuse this for Start/Pause text

        // Add Stop menu item (no key equivalent to avoid confusion)
        let stopItem = NSMenuItem(
            title: "Stop",
            action: #selector(stopTimer),
            keyEquivalent: ""
        )
        stopItem.isHidden = true // Hidden by default when idle
        menu.addItem(stopItem)
        stopMenuItem = stopItem

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Always on Top toggle
        let alwaysOnTopItem = NSMenuItem(
            title: "Always on Top",
            action: #selector(toggleAlwaysOnTop),
            keyEquivalent: ""
        )
        alwaysOnTopItem.state = windowManager.alwaysOnTop ? .on : .off
        menu.addItem(alwaysOnTopItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Dashboard menu item
        let dashboardItem = NSMenuItem(
            title: "Dashboard",
            action: #selector(showDashboard),
            keyEquivalent: ","
        )
        menu.addItem(dashboardItem)

        // Add separator
        menu.addItem(NSMenuItem.separator())

        // Add Quit menu item
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        // Assign menu to status item
        statusItem?.menu = menu

        // Setup observers for timer state changes
        setupTimerObservers()
    }

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

        // Update menu item checkmark
        if let menu = statusItem?.menu {
            for item in menu.items {
                if item.title == "Always on Top" {
                    item.state = windowManager.alwaysOnTop ? .on : .off
                }
            }
        }
    }

    @objc func showDashboard() {
        windowManager.showDashboardSettingsWindow()
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
