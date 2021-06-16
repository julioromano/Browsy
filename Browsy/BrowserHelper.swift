//
//  BrowserHelper.swift
//  Browsy
//
//  Created by julionb on 16/06/21.
//

import Foundation
import AppKit

class BrowserHelper {
    
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
    
    func openInSpecificBrowser(url: URL, bundleUrl: URL) -> () {
        NSWorkspace.shared.open(
            [url],
            withApplicationAt: bundleUrl,
            configuration: NSWorkspace.OpenConfiguration.init(),
            completionHandler: { _, _ in
                return
            }
        )
    }
}
