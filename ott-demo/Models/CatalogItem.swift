//
//  CatalogItem.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import Foundation

struct CatalogResponse: Codable {
    let items: [CatalogItem]
}

struct CatalogItem: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let thumbnail: String
    let streamUrl: String
    let duration: Int
    
    // Helper computed property for duration formatting
    var formattedDuration: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// Mock data for previews
extension CatalogItem {
    static let mockData = CatalogResponse(items: [
        CatalogItem(
            id: "bbb-hls",
            title: "Big Buck Bunny (HLS)",
            description: "Short animated film used as a demo stream.",
            thumbnail: "https://i.imgur.com/8GVG6Zp.jpeg",
            streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            duration: 596
        ),
        CatalogItem(
            id: "sintel-mp4",
            title: "Sintel (MP4)",
            description: "Open movie — MP4 fallback.",
            thumbnail: "https://i.imgur.com/DvpvklR.png",
            streamUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            duration: 888
        )
    ])
}
