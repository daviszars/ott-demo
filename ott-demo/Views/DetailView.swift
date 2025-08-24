//
//  DetailView.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import SwiftUI

struct DetailView: View {
    let catalogItem: CatalogItem
    @State private var showingPlayer = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Image with Play Button Overlay
                ZStack {
                    AsyncImageView(url: URL(string: catalogItem.thumbnail))
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                        .accessibilityLabel("Poster for \(catalogItem.title)")
                        .accessibilityHidden(true)
                    
                    // Play Button Overlay
                    Button(action: {
                        showingPlayer = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                                .offset(x: 2, y: 0) // Slight offset to center the play triangle
                        }
                    }
                    .accessibilityLabel("Play \(catalogItem.title)")
                    .accessibilityHint("Double tap to start playback")
                    .accessibilityAddTraits(.isButton)
                }
                .padding(.horizontal)
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text(catalogItem.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityAddTraits(.isHeader)
                        
                        // Duration (not in task requirements)
                        Text("Duration: \(catalogItem.formattedDuration)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("Duration: \(catalogItem.formattedDuration)")
                    }
                    .accessibilityElement(children: .combine)
                    
                    // Description
                    Text(catalogItem.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityLabel(catalogItem.description)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .sheet(isPresented: $showingPlayer) {
            PlayerView(catalogItem: catalogItem)
        }
    }
}

#Preview {
    NavigationView {
        DetailView(catalogItem: CatalogItem.mockData.items[0])
    }
}
