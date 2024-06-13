//
//  ChooserScreenPresenterTest.swift
//  BrowsyTests
//
//  Created by julionb on 31/05/24.
//

import XCTest
@testable import Browsy

class ChooserScreenPresenterTests: XCTestCase {
    var presenter: ChooserScreenPresenter!
    
    override func setUp() {
        super.setUp()
        presenter = ChooserScreenPresenter(
            browserManager: BrowserManagerFake(),
            url: URL(string: "https://www.apple.com")!
        )
    }
    
    override func tearDown() {
        presenter = nil
        super.tearDown()
    }
    
    func testOnBrowserClicked() {
        // Arrange
        let testBrowser = URL(string: "https://www.example.com")!
        
        // Act
        presenter.onBrowserClicked(testBrowser)
        
        // Assert
        // Replace this with the actual expected behavior
        XCTAssertEqual(presenter.state.url, "www.apple.com")
    }
}

class BrowserManagerFake: BrowserManager {
    func getBrowserIdentifiers() -> [Browser] {
        return aBrowserList()
    }
    
    func openURL(_ url: URL, in browserId: URL) {
        // no-op
    }
    
    func setAsDefaultBrowser() {
        // no-op
    }
}
