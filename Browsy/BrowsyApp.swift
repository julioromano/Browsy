//
//  BrowsyApp.swift
//  Browsy
//
//  Created by julionb on 10/06/21.
//

import SwiftUI

@main
struct BrowsyApp: App {
    
    @State private var lastUrl: URL? {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "lastUrl"),
                object: nil)
        }
    }
    
    @State private var browsers: [Bundle] = [Bundle]()
    
    var body: some Scene {
        WindowGroup {
            ContentView(url: lastUrl, browsers: browsers)
                .onOpenURL(perform: { url in
                    lastUrl = url
                    browsers = getInstalledBrowsers()
                })
        }
    }
    
    func getInstalledBrowsers () -> [ Bundle ] {
        var browsers = [ Bundle ]()
        let array = LSCopyAllHandlersForURLScheme("https" as CFString)?
            .takeRetainedValue()
        // let array = LSCopyAllRoleHandlersForContentType(
        //     "public.html" as CFString, LSRolesMask.all)?.takeRetainedValue()
        for i in 0..<CFArrayGetCount(array!) {
            let bundleId = unsafeBitCast(
                CFArrayGetValueAtIndex(array!, i),
                to: CFString.self
                ) as String
            if let path = NSWorkspace.shared
                .absolutePathForApplication(withBundleIdentifier: bundleId) {
                if let bundle = Bundle(path: path) {
                    // let name: String = bundle.infoDictionary!["CFBundleName"] as String
                    if bundle.bundleIdentifier == Bundle.main.bundleIdentifier {
                        continue
                    }
                    browsers.append(bundle)
                }
            }
        }
        return browsers
    }
}
