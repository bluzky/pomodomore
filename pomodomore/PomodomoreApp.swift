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

    var body: some Scene {
        // Settings scene doesn't auto-open on launch (unlike WindowGroup)
        // This ensures only the menubar icon shows, not a window
        Settings {
            EmptyView()
        }
    }
}
