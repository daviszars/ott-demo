//
//  HomeViewModel.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var catalogItems: [CatalogItem] = []
    @Published var filteredItems: [CatalogItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "" {
        didSet { filterItems() }
    }
    
    private let catalogService: CatalogServiceProtocol
    
    init(catalogService: CatalogServiceProtocol = CatalogService()) {
        self.catalogService = catalogService
    }
    
    func loadCatalog() async {
        isLoading = true
        defer { isLoading = false } // Loading ends when function exits
        
        do {
            clearError()
            Logger.log(.info, "Loading catalog...")
            let catalog = try await catalogService.fetchCatalog()
            catalogItems = catalog.items
            Logger.log(.info, "Loaded \(catalogItems.count) items")
            filterItems()
        } catch is CancellationError {
            // cancelled — ignore
        } catch {
            errorMessage = error.localizedDescription
            Logger.log(.error, "Failed to load catalog: \(error)")
        }
    }
    
    func refreshCatalog() async {
        do {
            clearError()
            Logger.log(.info, "Refreshing catalog...")
            let catalog = try await catalogService.fetchCatalog()
            catalogItems = catalog.items
            Logger.log(.info, "Refreshed \(catalogItems.count) items")
            filterItems()
        } catch is CancellationError {
            // ignore
        } catch {
            errorMessage = error.localizedDescription
            Logger.log(.error, "Failed to refresh catalog: \(error)")
        }
    }
    
    private func filterItems() {
        if searchText.isEmpty {
            filteredItems = catalogItems
        } else {
            let q = searchText
            filteredItems = catalogItems.filter {
                $0.title.localizedCaseInsensitiveContains(q)
            }
        }
    }
    
    private func clearError() { errorMessage = nil }
}
