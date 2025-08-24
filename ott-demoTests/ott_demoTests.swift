//
//  ott_demoTests.swift
//  ott-demoTests
//
//  Created by Davis Zarins on 22/08/2025.
//

import XCTest
@testable import ott_demo

final class ott_demoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCatalogItemDecodingFromJSON() throws {
        let jsonData = """
    {
        "id": "test1",
        "title": "Test Movie",
        "description": "A test description",
        "thumbnail": "https://example.com/thumb.jpg",
        "streamUrl": "https://example.com/video.mp4",
        "duration": 120
    }
    """.data(using: .utf8)!
        
        let catalogItem = try JSONDecoder().decode(CatalogItem.self, from: jsonData)
        
        XCTAssertEqual(catalogItem.id, "test1")
        XCTAssertEqual(catalogItem.title, "Test Movie")
        XCTAssertEqual(catalogItem.description, "A test description")
        XCTAssertEqual(catalogItem.streamUrl, "https://example.com/video.mp4")
        XCTAssertEqual(catalogItem.duration, 120)
    }
    
    @MainActor
    func testHomeViewModelInitialState() {
        let viewModel = HomeViewModel()
        
        XCTAssertTrue(viewModel.catalogItems.isEmpty)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor
    func testHomeViewModelSearchFiltering() {
        let viewModel = HomeViewModel()
        let mockItems = [
            CatalogItem(id: "1", title: "Action Movie", description: "Test", thumbnail: "", streamUrl: "", duration: 120),
            CatalogItem(id: "2", title: "Comedy Show", description: "Test", thumbnail: "", streamUrl: "", duration: 90)
        ]
        viewModel.catalogItems = mockItems
        
        viewModel.searchText = "action"
        
        XCTAssertEqual(viewModel.filteredItems.count, 1)
        XCTAssertEqual(viewModel.filteredItems.first?.title, "Action Movie")
    }
    
    @MainActor
    func testPlayerViewModelInitialState() {
        let catalogItem = CatalogItem(id: "1", title: "Test Movie", description: "Test", thumbnail: "", streamUrl: "", duration: 120)
        
        let viewModel = PlayerViewModel(catalogItem: catalogItem)
        
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNil(viewModel.player)
        XCTAssertEqual(viewModel.catalogItem.title, "Test Movie")
        XCTAssertEqual(viewModel.catalogItem.duration, 120)
    }
    
    func testCatalogItemFormattedDuration() {
        let item = CatalogItem(id: "1", title: "Test", description: "Test", thumbnail: "", streamUrl: "", duration: 125)
        
        XCTAssertEqual(item.formattedDuration, "2:05")
    }
}
