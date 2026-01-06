//
//  PomodomoreApp.swift
//  pomodomore
//
//  Created by Flex on 12/31/25.
//

import SwiftUI

@main
struct PomodomoreApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    /// Initialize settings manager early to ensure ConfigManager is updated
    init() {
        _ = SettingsManager.shared
        _ = ThemeManager.shared
        _ = FontManager.shared
    }

    var body: some Scene {
        // Settings scene doesn't auto-open on launch (unlike WindowGroup)
        // This ensures only the menubar icon shows, not a window
        SwiftUI.Settings {
            EmptyView()
        }
    }
}
