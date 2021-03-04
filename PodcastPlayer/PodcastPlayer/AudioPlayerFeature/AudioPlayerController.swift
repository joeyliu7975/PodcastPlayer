//
//  AudioPlayerController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/2/21.
//

import Foundation
import AVFoundation

public final class AudioPlayerController {
    private(set) var player:AVPlayer? {
        didSet {
            guard let player = player else { return }
                    
            player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in

                let isReadyToPlay = self.isReadyToPlay(status: player.currentItem?.status)
                
                if isReadyToPlay {
                    if self.totalDuration == nil {
                        self.getTotalDuration(currentPlayingItem: player.currentItem) { [weak self] (totalDuration) in
                            self?.totalDuration = totalDuration
                        }
                    }
                    
                    let time : Float64 = CMTimeGetSeconds(player.currentTime())
                    self.currentDuration = time
                    
                    if self.totalDuration == self.currentDuration {
                        self.askForNextEP?()
                    }
                }
            }
        }
    }
    
    private(set) var asset: AVAsset?
    private(set) var playerItem: AVPlayerItem?
    
     var currentDuration: Float64? {
        didSet {
            guard let currentDuration = currentDuration,
                  let totalDuration = totalDuration else { return }
            
            trackDuration?(currentDuration,totalDuration)
        }
    }
    
    private(set) var totalDuration: Float64?
    
    public var trackDuration: ((Float64, Float64) -> Void)?
    
    public var askForNextEP:(() -> Void)?
    
    static var shared = AudioPlayerController()
    
    private init() {}
}

extension AudioPlayerController {
    private func configure(url: URL) {
            //2. Create AVPlayer object
            asset = AVAsset(url: url)
            
            playerItem = AVPlayerItem(asset: asset!)
            
            player = AVPlayer(playerItem: playerItem)
            
            play()
    }

    // 重新換新的 url
    func replaceNewURL(with url: URL) {
        resetPlayer()
        
        self.configure(url: url)
    }
    
    func resetPlayer() {
        player?.pause()
        asset = nil
        playerItem = nil
        player = nil
    }
}

extension AudioPlayerController {
    //MARK: #1. Check player currentItem's playing status
    private func isReadyToPlay(status: AVPlayerItem.Status?) -> Bool {
        switch status {
        case .readyToPlay:
            return true
        default:
            return false
        }
    }
    
    //MARK: #2. Get total duration
    private func getTotalDuration(currentPlayingItem: AVPlayerItem?,_ completion: (Float64) -> Void) {
        guard
            let playingItem = currentPlayingItem else { return }
        
        let duration = playingItem.duration
        
        completion(CMTimeGetSeconds(duration))
    }
}


extension AudioPlayerController: PlayPauseProtocol {
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
}

extension AudioPlayerController: EpisodeProgressTracking {
    public func update(episodeCurrentDurationWith value: Float) {
        if let duration = playerItem?.duration
            {
            let totalSecond = CMTimeGetSeconds(duration)
            
            let value = (value) * Float(totalSecond)
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (_) in
                // Do something here
            })
        }
    }
}

extension AudioPlayerController: Controllable {
    public func nextEp(currentEpisode: EpisodeInfo, completion: (EpisodeInfo) -> Void) {}
    
    public func previousEp(currentEpisode: EpisodeInfo, completion: (EpisodeInfo) -> Void) {}
    
    public func progressControl(value: Float) {
        
    }
}
