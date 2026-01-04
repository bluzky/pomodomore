//
//  LoginItemsManager.swift
//  pomodomore
//
//  Manages login items for the application using ServiceManagement framework.
//  Allows the app to start automatically when the user logs in.
//

import Foundation
import ServiceManagement

/// Manages login items functionality for starting the app on user login
@MainActor
final class LoginItemsManager {
    static let shared = LoginItemsManager()

    private init() {}

    /// Check if the app is currently in login items
    var isLoginItemEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    /// Add the app to login items
    func enableLoginItem() throws {
        try SMAppService.mainApp.register()
    }

    /// Remove the app from login items
    func disableLoginItem() throws {
        try SMAppService.mainApp.unregister()
    }

    /// Toggle login item based on enabled state
    /// - Parameter enabled: Whether to enable or disable the login item
    func setLoginItem(enabled: Bool) {
        do {
            if enabled {
                try enableLoginItem()
            } else {
                try disableLoginItem()
            }
        } catch {
            print("Failed to update login item: \(error)")
        }
    }
}
