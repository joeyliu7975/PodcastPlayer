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
    private(set) var asset: AVAsset?
    private(set) var playerItem: AVPlayerItem?
    
    var timeObserver: Any?
    
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
    
    public var refreshProgress: ((Bool) -> Void)?
    
    static var shared = AudioPlayerController()
    
    private init() {}
}

extension AudioPlayerController {
    private func configure(url: URL, completion: @escaping () -> Void) {
            //2. Create AVPlayer object
            asset = AVAsset(url: url)
            
            playerItem = AVPlayerItem(asset: asset!)
            
            player = AVPlayer(playerItem: playerItem)
            
            completion()
    }
    
    func resetPlayer() {
        removeObserver()
        asset = nil
        playerItem = nil
        player = nil
        timeObserver = nil
    }
    
    func addObserver() {
        guard let player = player else { return }
        
        self.timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in

            let readyToPlay = player.currentItem?.status == .readyToPlay
            
            if readyToPlay {
                if self?.totalDuration == nil {
                    self?.getTotalDuration(currentPlayingItem: player.currentItem) { [weak self] (totalDuration) in
                        self?.totalDuration = totalDuration
                    }
                }
                
                let time : Float64 = CMTimeGetSeconds(player.currentTime())
                self?.currentDuration = time
                
                if self?.totalDuration == self?.currentDuration {
                    self?.askForNextEP?()
                }
            } 
        }
    }
    
    func removeObserver() {
        player?.currentItem?.cancelPendingSeeks()
        player?.currentItem?.asset.cancelLoading()
        player?.removeTimeObserver(timeObserver!)
    }

}

extension AudioPlayerController {
    
    //MARK: #1. Get total duration
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
            
            player?.seek(to: seekTime, completionHandler: { [weak self](_) in
                // Do something here
                let readyToPlay = self?.player?.currentItem?.status == .readyToPlay
                
                self?.refreshProgress?(readyToPlay)
            })
        }
    }
}

extension AudioPlayerController: EpisodeSoundLoader {
    public func load(with soundURL: URL) {
        configure(url: soundURL) { [weak self] in
            self?.addObserver()
            self?.play()
        }
    }
    
    // 重新換新的 url
    public func replaceNewURL(_ url: URL) {
        pause()
        self.asset = AVAsset(url: url)
        self.playerItem = AVPlayerItem(asset: asset!)
        self.player?.replaceCurrentItem(with: playerItem)
        
        play()
    }
}
