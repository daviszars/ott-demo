//
//  HomeView.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("columnCount") private var columnCount = 2
    @FocusState private var isSearchFocused: Bool
    @Namespace private var itemNamespace
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .focused($isSearchFocused)
                    
                    Group {
                        if viewModel.isLoading && viewModel.catalogItems.isEmpty {
                            LoadingView().padding(.top, 8)
                        } else if let errorMessage = viewModel.errorMessage {
                            ErrorView(message: errorMessage) {
                                Task { await viewModel.loadCatalog() }
                            }
                            .padding(.top, 8)
                        } else {
                            contentView
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .refreshable { await viewModel.refreshCatalog() }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        columnCount = columnCount == 1 ? 2 : 1 // Toggle between 1 and 2 columns (list and grid view)
                    } label: {
                        Image(systemName: columnCount == 1 ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
                    }
                    .accessibilityLabel(columnCount == 1 ? "Switch to grid layout" : "Switch to list layout")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isSearchFocused = !isSearchFocused } label: { Image(systemName: "magnifyingglass") }
                        .accessibilityLabel("Search")
                }
            }
            .task {
                if viewModel.catalogItems.isEmpty {
                    await viewModel.loadCatalog()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var contentView: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(0..<max(1, columnCount), id: \.self) { col in
                VStack(spacing: 24) { // Normally I would use LazyVStack, but it messes with animations because of view recycling
                    ForEach(itemsForColumn(col, totalColumns: max(1, columnCount), items: viewModel.filteredItems), id: \.id) { catalogItem in
                        NavigationLink(destination: DetailView(catalogItem: catalogItem)) {
                            CatalogItemCell(catalogItem: catalogItem)
                                .matchedGeometryEffect(id: catalogItem.id, in: itemNamespace) // For smooth animations between each item
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .scale(scale: 0.97)),
                                    removal: .opacity
                                ))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
        // animate layout change and item changes
        .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.8), value: viewModel.filteredItems)
        .animation(.easeInOut(duration: 0.28), value: columnCount)
    }
    
    private func itemsForColumn(_ column: Int, totalColumns: Int, items: [CatalogItem]) -> [CatalogItem] {
        guard totalColumns > 0 else { return items }
        return stride(from: column, to: items.count, by: totalColumns).map { items[$0] }
    }
}

// MARK: SearchBar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Search videos...", text: $text)
                .textFieldStyle(.plain)
                .accessibilityLabel("Search videos")
                .accessibilityHint("Type to filter videos")
            
            if !text.isEmpty {
                Button("Clear") { text = "" }
                    .foregroundStyle(.blue)
                    .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .accessibilityElement(children: .combine)
    }
}

// MARK: LoadingView
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            
            Text("Loading videos...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading videos")
    }
}

// MARK: ErrorView
struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
                .accessibilityHidden(true)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again", action: retryAction)
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Retry loading videos")
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Something went wrong: \(message)")
    }
}

#Preview {
    HomeView()
}
