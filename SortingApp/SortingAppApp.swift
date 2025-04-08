//
//  SortingAppApp.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI

@main
struct SortingAppApp: App {
    var body: some Scene {
        WindowGroup {
            SortingView()
        }
        #if os(macOS)
        .commands {
            // Replace app info menu with About
            CommandGroup(replacing: .appInfo) {
                Button("About Sorting Visualizer") {
                    NSApp.orderFrontStandardAboutPanel()
                }
            }
            
            // Add our custom settings commands
            MacSettingsCommands()
            
            // Remove View menu
            CommandGroup(replacing: .sidebar) { }
            
            // Remove Window menu
            CommandGroup(replacing: .windowList) { }
            
            // Remove File menu
            CommandGroup(replacing: .newItem) { }
            
            // Remove Edit menu
            CommandGroup(replacing: .pasteboard) { }
            CommandGroup(replacing: .undoRedo) { }
        }
        #endif
    }
}
