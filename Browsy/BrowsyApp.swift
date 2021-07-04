//
//  BrowsyApp.swift
//  Browsy
//
//  Created by julionb on 10/06/21.
//

import SwiftUI

@main
struct BrowsyApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView() // Hack to not show any window on app startup.
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    let application: NSApplication = NSApplication.shared
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // createMenu()
        
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
//    @objc func quit() {
//        application.terminate(self)
//    }
    
    @objc func handleGetURLEvent(replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = replyEvent?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            let urlStr = aeEventDescriptor.stringValue
            openWindow(url: URL(string: urlStr!)!)
        }
    }
    
    private func openWindow(url: URL) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(
            rootView: ContentView(url: url, browsers: BrowserHelper().getInstalledBrowsers())
        )
        window.makeKeyAndOrderFront(nil)
    }
    
//    private func createMenu() {
//        let menu = NSMenu()
//        let appNameMenuItem = NSMenuItem(title: "Browsy v0.1", action: nil, keyEquivalent: "")
//        let swiftUiMenuItem = NSMenuItem()
//        let swiftUiView = NSHostingView(rootView: Text("Welcome!"))
//        swiftUiView.frame = NSRect(x: 0, y: 0, width: 115, height: 40)
//        swiftUiMenuItem.view = swiftUiView
//        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
//        menu.addItem(appNameMenuItem)
//        menu.addItem(swiftUiMenuItem)
//        menu.addItem(quitMenuItem)
//        statusBarItem.menu = menu
//        statusBarItem.button?.image = NSImage(named: "MenuBarIcon")
//    }
}
