//
//  BrowsyAppDelegate.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import AppKit

class BrowsyAppDelegate: NSObject, NSApplicationDelegate {
    
    private let chooserWindowManager: ChooserWindowManager
    private let browserManager: BrowserManager
    
    override init() {
        chooserWindowManager = BrowsyApp.dependencies.chooserWindowManager
        browserManager = BrowsyApp.dependencies.browserManager()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(event:replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        browserManager.setAsDefaultBrowser()
    }
    
    @objc func handleGetURLEvent(
        event: NSAppleEventDescriptor,
        replyEvent: NSAppleEventDescriptor
    ) {
        if let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue, let url = URL(string: urlString) {
            chooserWindowManager.showChooserWindow(url: url)
        }
    }
}
