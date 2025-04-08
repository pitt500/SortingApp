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
            MacSettingsCommands()
        }
        #endif
    }
}
