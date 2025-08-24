//
//  AsyncImageView.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import SwiftUI
import UIKit

actor ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    // Fetch + cache using URLSession async/await
    func load(url: URL) async throws -> UIImage {
        if let cached = cache.object(forKey: url as NSURL) {
            Logger.log(.info, "Cache hit for: \(url.lastPathComponent)")
            return cached
        }
        
        Logger.log(.info, "Downloading: \(url.lastPathComponent)")
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let img = UIImage(data: data) else {
            Logger.log(.error, "Failed to decode image data from \(url)")
            throw URLError(.cannotDecodeContentData)
        }
        
        cache.setObject(img, forKey: url as NSURL)
        return img
    }
}

struct AsyncImageView: View {
    let url: URL?
    
    @State private var uiImage: UIImage?
    @State private var failed = false
    
    var body: some View {
        ZStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .accessibilityHidden(true)
            } else if failed {
                // Placeholder
                VStack(spacing: 4) {
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                        .font(.title2)
                    
                    Text("No Image")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .frame(minHeight: 100)
                .aspectRatio(16/9, contentMode: .fit)
                .accessibilityLabel("No image available")
            } else {
                // Loading state
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .accessibilityLabel("Loading image")
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .task(id: url) {
            guard let url else {
                failed = true
                return
            }
            
            failed = false
            
            do {
                let img = try await ImageCache.shared.load(url: url)
                withAnimation(.easeInOut(duration: 0.25)) {
                    uiImage = img
                    failed = false
                }
            } catch {
                failed = true
            }
        }
    }
}

#Preview {
    AsyncImageView(url: URL(string: "https://i.imgur.com/DvpvklR.png"))
}
