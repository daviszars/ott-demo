//
//  ott_demoUITests.swift
//  ott-demoUITests
//
//  Created by Davis Zarins on 22/08/2025.
//

import XCTest

final class ott_demoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testSearchFlowFiltersResults() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for content
        let catalogCells = app.buttons.matching(identifier: "catalog-item-cell")
        let firstCell = catalogCells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        let initialItemCount = catalogCells.count
        XCTAssertGreaterThan(initialItemCount, 0, "Should have catalog items")
        
        // Search with unlikely text
        let searchField = app.textFields["Search videos..."]
        searchField.tap()
        searchField.typeText("xyz123")
        
        sleep(1)
        
        let filteredItemCount = catalogCells.count
        XCTAssertLessThan(filteredItemCount, initialItemCount, "Search should reduce results")
        
        // Clear search
        if app.buttons["Clear search"].exists {
            app.buttons["Clear search"].tap()
            sleep(1)
            let restoredItemCount = catalogCells.count
            XCTAssertEqual(restoredItemCount, initialItemCount, "Should restore all items")
        }
    }
    
    @MainActor
    func testHomeToDetailsToPlayerFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for catalog items and tap first one
        let catalogCells = app.buttons.matching(identifier: "catalog-item-cell")
        let firstCatalogItem = catalogCells.firstMatch
        XCTAssertTrue(firstCatalogItem.waitForExistence(timeout: 5))
        firstCatalogItem.tap()
        
        // Tap play button on detail view
        let playButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'play'")).firstMatch
        XCTAssertTrue(playButton.waitForExistence(timeout: 3))
        playButton.tap()
        
        // Verify player appears
        let playerElement = app.otherElements["Video player"]
        XCTAssertTrue(playerElement.waitForExistence(timeout: 5))
    }
}
