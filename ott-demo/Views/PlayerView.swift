//
//  PlayerView.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    let catalogItem: CatalogItem
    @StateObject private var viewModel: PlayerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    init(catalogItem: CatalogItem) {
        self.catalogItem = catalogItem
        self._viewModel = StateObject(wrappedValue: PlayerViewModel(catalogItem: catalogItem))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            // Player Content
            if let errorMessage = viewModel.errorMessage {
                // Error State
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .accessibilityHidden(true)
                    
                    Text("Playback Error")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .accessibilityAddTraits(.isHeader)
                    
                    Text(errorMessage)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .accessibilityLabel(errorMessage)
                    
                    Button("Close") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityLabel("Close")
                }
                .padding()
                .accessibilityElement(children: .combine)
            } else if let player = viewModel.player {
                // Video Player
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .offset(y: dragOffset.height)
                    .scaleEffect(isDragging ? max(0.85, 1 - abs(dragOffset.height) / 800.0) : 1)
                    .opacity(isDragging ? max(0.5, 1 - abs(dragOffset.height) / 400.0) : 1)
                    .accessibilityLabel("Video player")
            }
            
            // Swipe indicator
            VStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white)
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .opacity(isDragging ? 0.8 : 0.3)
                    .accessibilityHidden(true)
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Only allow downward swipes to dismiss
                    if value.translation.height > 0 {
                        dragOffset = value.translation
                        isDragging = true
                    }
                }
                .onEnded { value in
                    isDragging = false
                    
                    if value.translation.height > 150 || value.predictedEndTranslation.height > 300 {
                        // Dismiss if dragged down far enough or with enough velocity
                        dismiss()
                    } else {
                        // Snap back to original position with animation
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            dragOffset = .zero
                        }
                    }
                }
        )
        .onAppear {
            viewModel.setupPlayer()
            // Auto-play after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.play()
            }
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
}

#Preview {
    PlayerView(catalogItem: CatalogItem.mockData.items[0])
}
