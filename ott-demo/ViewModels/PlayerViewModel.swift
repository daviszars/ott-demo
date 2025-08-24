//
//  PlayerViewModel.swift
//  ott-demo
//
//  Created by Davis Zarins on 22/08/2025.
//

import Foundation
import AVFoundation
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var errorMessage: String?
    
    var player: AVPlayer?
    
    let catalogItem: CatalogItem
    
    init(catalogItem: CatalogItem) {
        self.catalogItem = catalogItem
    }
    
    func setupPlayer() {
        guard let url = URL(string: catalogItem.streamUrl) else {
            Logger.log(.error, "Invalid video URL: \(catalogItem.streamUrl)")
            errorMessage = "Invalid video URL"
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        observePlayerStatus(playerItem)
        errorMessage = nil
    }
    
    func play() {
        guard let player = player else {
            setupPlayer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.play()
            }
            return
        }
        
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func cleanup() {
        player?.pause()
        player = nil
        isPlaying = false
    }
    
    private func observePlayerStatus(_ playerItem: AVPlayerItem) {
        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                switch status {
                case .failed:
                    self?.errorMessage = playerItem.error?.localizedDescription ?? "Playback failed"
                    self?.isPlaying = false
                    Logger.log(.error, "Player item failed: \(self?.errorMessage ?? "unknown error")")
                case .readyToPlay:
                    self?.errorMessage = nil
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
}
