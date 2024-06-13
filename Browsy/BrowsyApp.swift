//
//  BrowsyApp.swift
//  Browsy
//
//  Created by julionb on 30/05/24.
//

import SwiftUI

@main
struct BrowsyApp: App {
    static let dependencies = Dependencies()
    
    @NSApplicationDelegateAdaptor(BrowsyAppDelegate.self) var appDelegate: BrowsyAppDelegate
    
    var body: some Scene {
        MenuBarExtra("Browsy", image: "MenuIcon") {
            MenuView(
                quitAction: { NSApplication.shared.terminate(self) },
                checkForUpdates: { BrowsyApp.dependencies.spuStandardUpdaterController.updater.checkForUpdates() }
            )
        }
    }
}
