//
//  ChooserWindowManager.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import SwiftUI

protocol ChooserWindowManager {
    func showChooserWindow(url: URL)
}

class ChooserWindowManagerImpl: ChooserWindowManager {
    private let chooserScreenPresenterFactory: (URL) -> ChooserScreenPresenter
    private let window: NSPanel
    
    init(
        chooserScreenPresenterFactory: @escaping (URL) -> ChooserScreenPresenter
    ) {
        self.chooserScreenPresenterFactory = chooserScreenPresenterFactory
        window = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [],
            backing: .buffered,
            defer: false
        )
        window.backgroundColor = NSColor.clear
        window.isReleasedWhenClosed = false
    }
    
    func showChooserWindow(url: URL) {
        window.contentView = NSHostingView(
            rootView: ChooserScreenBindingView(presenter: chooserScreenPresenterFactory(url))
        )
        window.setFrameOrigin(NSEvent.mouseLocation)
        window.orderFront(nil)
    }
}
