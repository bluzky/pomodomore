//
//  pomodomoreApp.swift
//  pomodomore
//
//  Created by Flex on 12/31/25.
//

import SwiftUI
import SwiftData

@main
struct pomodomoreApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Commented out SwiftData boilerplate - will be used later for session persistence
    /*
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    */

    var body: some Scene {
        // Empty WindowGroup - menubar app doesn't need initial window
        // Timer window will be created later (Day 2)
        WindowGroup {
            EmptyView()
        }
        // .modelContainer(sharedModelContainer)  // Commented out for now
    }
}
