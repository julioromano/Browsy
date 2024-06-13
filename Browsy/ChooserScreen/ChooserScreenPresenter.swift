//
//  ChooserScreenPresenter.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import AppKit

class ChooserScreenPresenter: ObservableObject {
    
    @Published private(set) var state: ChooserScreenState = ChooserScreenState(url: nil, browsers: [])
    
    private let browserManager: BrowserManager
    private let url: URL
    
    init(
        browserManager: BrowserManager,
        url: URL
    ) {
        self.browserManager = browserManager
        self.url = url
        self.state = ChooserScreenState(url: url.host(), browsers: browserManager.getBrowserIdentifiers())
    }
    
    func onBrowserClicked(_ browser: URL) {
        browserManager.openURL(url, in: browser)
        NSApplication.shared.keyWindow?.close()
    }
}

struct ChooserScreenState {
    let url: String?
    let browsers: [Browser]
}
