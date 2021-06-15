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
    
    @State private var lastUrl: URL?
    @State private var browsers: [Bundle] = [Bundle]()
    
    var body: some Scene {
        WindowGroup {
            if let url = lastUrl {
                ContentView(url: url, browsers: browsers)
                    .onOpenURL(perform: { url in
                        lastUrl = url
                        browsers = getInstalledBrowsers()
                    })
            }
        }
        Settings {
            EmptyView()
        }
    }
    
    func getInstalledBrowsers() -> [ Bundle ] {
        var browsers = [ Bundle ]()
        let array = LSCopyApplicationURLsForURL(URL(string: "https:")! as CFURL, .all)?.takeRetainedValue()
        for i in 0..<CFArrayGetCount(array!) {
            let url = unsafeBitCast(CFArrayGetValueAtIndex(array!, i), to: CFURL.self) as URL
            if let bundle = Bundle(url: url) {
                if bundle.bundleIdentifier == Bundle.main.bundleIdentifier {
                    continue
                }
                browsers.append(bundle)
            }
        }
        return browsers
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem?
    var application: NSApplication = NSApplication.shared
    var myProperty: String = ""
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu()
        let menuItem = NSMenuItem()
        
        // SwiftUI View
        let view = NSHostingView(rootView: ContentView(url: URL(string: "www.apple.com")!, browsers: [Bundle]()))
        
        // Very important! If you don't set the frame the menu won't appear to open.
        view.frame = NSRect(x: 0, y: 0, width: 115, height: 115)
        menuItem.view = view
        
        menu.addItem(menuItem)
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem?.button?.title = "Test"
        statusBarItem?.menu = menu
    }
}
