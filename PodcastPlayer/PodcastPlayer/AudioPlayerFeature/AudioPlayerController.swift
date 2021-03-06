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
    
    private var timeObserver: Any?
    
    private var isSeekInProgress = false
    
    private var playerCurrentItemStatus: AVPlayerItem.Status = .unknown
    
    private var chaseTime: CMTime = .zero
    
    public var trackDuration: ((Float64, Float64) -> Void)?
    
    public var playNextEP:(() -> Void)?
    
    public var updateProgress: ((Bool) -> Void)?
}

extension AudioPlayerController {
    func resetPlayer() {
        removeObserver()
        player = nil
        timeObserver = nil
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
    public func update(episodeCurrentDurationWith sliderValue: Float) {
        if let duration = player?.currentItem?.duration {
            let totalSecond = CMTimeGetSeconds(duration)
            
            let value = (sliderValue) * Float(totalSecond)
            
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            stopPlayingAndSeekSmoothlyToTime(newChaseTime: seekTime)
        }
    }
}

//MARK: Apple Answer to handle AVPlayer seekTime:
private extension AudioPlayerController {
    func stopPlayingAndSeekSmoothlyToTime(newChaseTime:CMTime)
    {
        pause()
        
        if CMTimeCompare(newChaseTime, chaseTime) != 0 {
            chaseTime = newChaseTime
            
            if !isSeekInProgress {
                trySeekToChaseTime()
            }
        }
    }
    
    func trySeekToChaseTime() {
        if playerCurrentItemStatus == .unknown
        {
            // wait until item becomes ready (KVO player.currentItem.status)
        } else if playerCurrentItemStatus == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        
        player?.seek(to: seekTimeInProgress, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { (isFinished) in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
                self.updateProgress?(!self.isSeekInProgress)
            } else {
                self.updateProgress?(!self.isSeekInProgress)
                self.trySeekToChaseTime()
            }
        })
    }
    // MARK: #Configuration:
    func configure(url: URL, completion: @escaping () -> Void) {
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        player = AVPlayer(playerItem: playerItem)
        
        completion()
    }
    // MARK: #Add Observer
    func addObserver() {
        guard let player = player else { return }
        
        self.timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            
            self?.playerCurrentItemStatus = player.currentItem?.status ?? .unknown
            
            if player.currentItem?.status == .readyToPlay,
               let duration = player.currentItem?.duration {
                let totalDuration = CMTimeGetSeconds(duration)
                let currentDuration = CMTimeGetSeconds(player.currentTime())
                
                if currentDuration == totalDuration {
                    self?.playNextEP?()
                } else {
                    self?.trackDuration?(currentDuration, totalDuration)
                }
            }
        }
    }
    // MARK: #Remove Observer
    func removeObserver() {
        player?.currentItem?.cancelPendingSeeks()
        player?.currentItem?.asset.cancelLoading()
        
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
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
    public func replace(url: URL) {
        pause()
    
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        player?.replaceCurrentItem(with: playerItem)
        
        play()
    }
}
