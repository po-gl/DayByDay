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
        setupPlayer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeLayer), name: UIApplication.didEnterBackgroundNotification, object: UIApplication.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func setupPlayer() {
        guard let fileURL = Bundle.main.url(forResource: name, withExtension: "mov") else { return }
        
        Task {
            do {
                let asset = AVAsset(url: fileURL)
                let isPlayable = try await asset.load(.isPlayable)
                if isPlayable {
                    let item = AVPlayerItem(asset: asset)
                    player = AVQueuePlayer()
                    player?.automaticallyWaitsToMinimizeStalling = false
                    playerLayer.player = player
                    playerLayer.videoGravity = .resize
                    layer.addSublayer(playerLayer)
                    
                    self.playerLooper = AVPlayerLooper(player: self.player!, templateItem: item)
                    self.player?.playImmediately(atRate: 1.0)
                }
            } catch {
                print("There was an error setting up AVPlayer \(error.localizedDescription)")
            }
        }
    }
    
    
    @objc
    private func refresh() {
        setupPlayer()
    }
    
    @objc
    private func removeLayer() {
        self.playerLayer.removeFromSuperlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
