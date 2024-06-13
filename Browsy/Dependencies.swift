//
//  Dependencies.swift
//  Browsy
//
//  Created by julionb on 31/05/24.
//

import AppKit
import Sparkle

class Dependencies {
    
    lazy var spuStandardUpdaterController: SPUStandardUpdaterController = spuStandardUpdaterControllerFactory()
    
    lazy var chooserWindowManager: ChooserWindowManager = chooserWindowManagerFactory(
        { url in
            self.chooserScreenPresenterFactory(
                self.browserManagerFactory(self.bundleMainUrlFactory(), self.nsWorkspaceFactory()),
                url
            )
        }
    )
    
    func browserManager() -> BrowserManager {
        return browserManagerFactory(bundleMainUrlFactory(), nsWorkspaceFactory())
    }
    
    func chooserScreenPresenter(url: URL) -> ChooserScreenPresenter {
        return chooserScreenPresenterFactory(
            browserManagerFactory(bundleMainUrlFactory(), nsWorkspaceFactory()),
            url
        )
    }
    
    private let chooserWindowManagerFactory: (@escaping (URL) -> ChooserScreenPresenter) -> ChooserWindowManager = { chooserScreenPresenterFactory in
        return ChooserWindowManagerImpl(
            chooserScreenPresenterFactory: chooserScreenPresenterFactory
        )
    }
    
    private let browserManagerFactory: (URL, NSWorkspace) -> BrowserManager = { bundleMainUrl, nsWorkspace in
        return BrowserManagerImpl(
            bundleMainUrl: bundleMainUrl,
            nsWorkspace: nsWorkspace
        )
    }
    
    private let chooserScreenPresenterFactory = { browserManager, url in
        ChooserScreenPresenter(browserManager: browserManager, url: url)
    }
    
    private let bundleMainUrlFactory: () -> URL = { Bundle.main.bundleURL }
    
    private let nsWorkspaceFactory: () -> NSWorkspace = { NSWorkspace.shared }
    
    private let spuStandardUpdaterControllerFactory: () -> SPUStandardUpdaterController = {
        SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }
}
