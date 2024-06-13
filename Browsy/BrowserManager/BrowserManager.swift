//
//  BrowserManager.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import AppKit

protocol BrowserManager {
    func getBrowserIdentifiers() -> [Browser]
    func openURL(_ url: URL, in browserId: URL)
    func setAsDefaultBrowser()
}

class BrowserManagerImpl : BrowserManager {
    
    private let bundleMainUrl: URL
    private let nsWorkspace: NSWorkspace
    
    init(
        bundleMainUrl: URL,
        nsWorkspace: NSWorkspace
    ) {
        self.bundleMainUrl = bundleMainUrl
        self.nsWorkspace = nsWorkspace
    }
    
    func getBrowserIdentifiers() -> [Browser] {
        guard let schemeURL = URL(string: "https:") else {
            return []
        }
        let htmlHandlerAppsURLs: [URL]
        let httpsHandlerAppsURLs: [URL]
        htmlHandlerAppsURLs = nsWorkspace.urlsForApplications(toOpen: .html)
        httpsHandlerAppsURLs = nsWorkspace.urlsForApplications(toOpen: schemeURL)
        
        return Set(htmlHandlerAppsURLs)
            .intersection(httpsHandlerAppsURLs)
            .filter { $0 != bundleMainUrl }
            .compactMap { url in
                guard let bundle = Bundle(url: url) else {
                    return nil
                }
                let icon = nsWorkspace.icon(forFile: url.path)
                let name = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
                return Browser(name: name, icon: icon, appUrl: url)
            }
    }
    
    func openURL(_ url: URL, in browserId: URL) {
        nsWorkspace.open(
            [url],
            withApplicationAt: browserId,
            configuration: NSWorkspace.OpenConfiguration()
        ) { (app, error) in
            if let error = error {
                print("Failed to open URL \(url) with application \(browserId): \(error)")
            }
        }
    }
    
    func setAsDefaultBrowser() {
        nsWorkspace.setDefaultApplication(
            at: bundleMainUrl,
            toOpenURLsWithScheme: "http"
        )
    }
}
