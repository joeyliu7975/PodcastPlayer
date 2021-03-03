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
    
    public var url: URL? {
        didSet {
            guard url != nil else { return }
            configure()
        }
    }
    
    init(url: URL? = nil) {
        self.url = url
    }
}

extension AudioPlayerController {
    private func configure() {
        if let url = url {
            //2. Create AVPlayer object
            asset = AVAsset(url: url)
            
            playerItem = AVPlayerItem(asset: asset!)
            
            player = AVPlayer(playerItem: playerItem)
            
            //5. Play Video
            player?.play()
        }
    }
}

extension AudioPlayerController: Playable {
    public func play() {}
    
    public func pause() {}
}

extension AudioPlayerController: Controllable {
    public func nextEp(currentEpisode: EpisodeInfo, completion: (EpisodeInfo) -> Void) {}
    
    public func previousEp(currentEpisode: EpisodeInfo, completion: (EpisodeInfo) -> Void) {}
    
    public func progressControl(value: Float) {}
}
