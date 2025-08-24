//
//  CatalogItemCell.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import SwiftUI

struct CatalogItemCell: View {
    let catalogItem: CatalogItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail
            AsyncImageView(
                url: URL(string: catalogItem.thumbnail)
            )
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
            .clipped()
            .accessibilityHidden(true)
            
            // Title
            VStack(alignment: .leading, spacing: 4) {
                Text(catalogItem.title)
                    .font(.headline)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)
            }
            .padding(.horizontal, 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(catalogItem.title)")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Double tap to view details")
        .accessibilityIdentifier("catalog-item-cell")
    }
}

#Preview {
    CatalogItemCell(catalogItem: CatalogItem.mockData.items[0])
}
