//
//  AudioPlayerController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/2/21.
//

import Foundation
import AVFoundation

public final class AudioPlayerController {
    private(set) var player:AVPlayer?
    private(set) var asset:AVAsset?
    private(set) var playerItem:AVPlayerItem?
    private(set) var url: URL? {
        didSet {
            if (oldValue?.absoluteURL) != url?.absoluteURL {
                configurePlayer()
            }
        }
    }
    
    static let shared = AudioPlayerController()

    private init() {}
    
    public func configure(with url: URL){
        self.url = url
    }
    
    private func configurePlayer() {
        guard let url = self.url else { return }
        asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem)
    }
    
    public func play(completion: @escaping (Float) -> Void) {
        player?.play()
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            let value = CMTimeGetSeconds(currentTime) / CMTimeGetSeconds(duration)
            completion(Float(value))
        }
    }
    
    public func pause() {
        player?.pause()
    }
    
    func rewindVideo(by seconds: Float64 = 5.0) {
        if let currentTime = player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - seconds
            if newTime <= 0 {
                newTime = 0
            }
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    func forwardVideo(by seconds: Float64 = 5.0) {
        if let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + seconds
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            
            player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }

}
