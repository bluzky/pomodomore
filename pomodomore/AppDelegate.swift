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

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // Set initial title with just tomato emoji
            button.title = "🍅"
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

        // Add Stop menu item
        let stopItem = NSMenuItem(
            title: "Stop",
            action: #selector(stopTimer),
            keyEquivalent: "r"
        )
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

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // Keep app running even when all windows are closed
        return false
    }

    // MARK: - Timer Status Updates

    private func setupTimerObservers() {
        // Observe time remaining changes
        windowManager.timerViewModel.$timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenubarStatus()
            }
            .store(in: &cancellables)

        // Observe timer state changes
        windowManager.timerViewModel.$currentState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenubarStatus()
            }
            .store(in: &cancellables)

        // Observe session type changes
        windowManager.timerViewModel.$currentSessionType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenubarStatus()
            }
            .store(in: &cancellables)
    }

    private func updateMenubarStatus() {
        let viewModel = windowManager.timerViewModel
        let timeText = viewModel.timeFormatted

        // Update menubar button title (shows countdown time only)
        // Show time when running or paused, hide when idle or completed
        if let button = statusItem?.button {
            switch viewModel.currentState {
            case .running, .paused:
                button.title = timeText
            case .idle, .completed:
                button.title = "🍅"
            }
        }

        // Update Start/Pause menu item text
        timerStatusMenuItem?.title = viewModel.primaryActionTitle
    }
}
