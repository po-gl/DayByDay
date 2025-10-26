//
//  AnimationView.swift
//  DayByDay
//
//  Created by Porter Glines on 2/28/23.
//

import SwiftUI
import AVKit

struct AnimationView: UIViewRepresentable {
    let name: String
    
    func makeUIView(context: Context) -> some UIView {
        return AnimationUIView(name: name)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


class AnimationUIView: UIView {
    private var playerLooper: AVPlayerLooper?
    private var playerLayer = AVPlayerLayer()
    private var player: AVQueuePlayer?
    private var name: String?
    
    required init(name: String) {
        super.init(frame: .zero)
        self.name = name
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeLayer), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeLayer), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setupPlayer()
    }
    
    deinit {
        print("Deinit called")
        NotificationCenter.default.removeObserver(self)
        teardownPlayer()
    }
    
    private func setupPlayer() {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "mov") else { return }
        
        // Ensure we don't stack multiple layers or players
        if playerLayer.superlayer == nil {
            layer.addSublayer(playerLayer)
        }
        
        // Tear down any existing player before setting up a new one
        teardownPlayer()
        
        Task {
            do {
                let asset = AVURLAsset(url: fileURL)
                let isPlayable = try await asset.load(.isPlayable)
                if isPlayable {
                    let item = AVPlayerItem(asset: asset)
                    player = AVQueuePlayer()
                    player?.isMuted = true
                    player?.automaticallyWaitsToMinimizeStalling = false
                    playerLayer.player = player
                    
                    self.playerLooper = AVPlayerLooper(player: self.player!, templateItem: item)
                    self.player?.playImmediately(atRate: 1.0)
                }
            } catch {
                print("There was an error setting up AVPlayer \(error.localizedDescription)")
            }
        }
    }
    
    private func teardownPlayer() {
        player?.pause()
        playerLooper = nil
        playerLayer.player = nil
        player = nil
    }
    
    @objc
    private func refresh() {
        setupPlayer()
    }
    
    @objc
    private func removeLayer() {
        teardownPlayer()
        playerLayer.removeFromSuperlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
