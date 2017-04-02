//
//  AppDelegate.swift
//  Browsy
//
//  Created by julionb on 31/03/2017.
//  Copyright © 2017 kJulio. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var lastUrl: URL? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lastUrl"), object: nil)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    override func awakeFromNib() {
        let eventManager = NSAppleEventManager.shared()
        eventManager.setEventHandler(
            self,
            andSelector: #selector(self.handleGetURLEvent(replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    func handleGetURLEvent(replyEvent: NSAppleEventDescriptor?) {
        if let aeEventDescriptor = replyEvent?.paramDescriptor(forKeyword: AEKeyword(keyDirectObject)) {
            let urlStr = aeEventDescriptor.stringValue
            lastUrl = URL(string: urlStr!)!
        }
        
    }
    
    /// appId: `nil` use the default HTTP client, or set what you want, e.g. Safari `com.apple.Safari`
    func openInSpecificBrowser(url: URL, appId: String? = nil) -> Bool {
        return NSWorkspace.shared().open(
            [url],
            withAppBundleIdentifier: appId,
            options: NSWorkspaceLaunchOptions.default,
            additionalEventParamDescriptor: nil,
            launchIdentifiers: nil
        )
    }
    
    func openLastUrl(appId: String? = nil) -> Bool {
        if (lastUrl != nil) {
            return openInSpecificBrowser(url: lastUrl!, appId: appId)
        } else {
            return false
        }
    }
    
}
