//
//  AudioPlayerController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/2/21.
//

import Foundation
import AVFoundation

public final class AVPlayerController {
    private var player:AVPlayer?
    
    private var timeObserver: Any?
    
    private var isSeekInProgress = false
    
    private var currentPlayingItemStatus: AVPlayerItem.Status = .unknown
    
    private var chaseTime: CMTime = .zero
    // 更新 Audio 的進度
    public var trackDuration: ((Float) -> Void)?
    // 更新播放狀態(play/pause)
    public var notify: ((Bool) -> Void)?
    // 播放下一集
    public var playNextEP:(() -> Void)?
    
    public init(){}
}

extension AVPlayerController {
    func resetPlayer() {
        removeObserver()
        player = nil
        timeObserver = nil
    }
}

extension AVPlayerController {
    //MARK: #1. Get total duration
    private func getTotalDuration(currentPlayingItem: AVPlayerItem?,_ completion: (Float64) -> Void) {
        guard
            let playingItem = currentPlayingItem else { return }
        
        let duration = playingItem.duration
        
        completion(CMTimeGetSeconds(duration))
    }
}

extension AVPlayerController: PlayPauseProtocol {
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
}

extension AVPlayerController: EpisodeProgressTracking {
    
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
private extension AVPlayerController {
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
        if currentPlayingItemStatus == .unknown
        {
            // wait until item becomes ready (KVO player.currentItem.status)
        } else if currentPlayingItemStatus == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    func actuallySeekToTime() {
        isSeekInProgress = true
        let seekTimeInProgress = chaseTime
        
        player?.seek(to: seekTimeInProgress, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { (isFinished) in
            if CMTimeCompare(seekTimeInProgress, self.chaseTime) == 0 {
                self.isSeekInProgress = false
            } else {
                self.trySeekToChaseTime()
            }
            
            self.notify?(!self.isSeekInProgress)
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
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            // 更新 PlayerCurrentItem 的 Status
           self?.itemReadyToPlay(player.currentItem?.status)
            
            if self?.currentPlayingItemStatus == .readyToPlay,
               let currentItem = player.currentItem {
                
                let totalDuration = CMTimeGetSeconds(currentItem.duration)
                let currentDuration = CMTimeGetSeconds(player.currentTime())
                
                self?.updateItemProgress(currentDuration: currentDuration, totalDuration: totalDuration)
            }
        }
    }
    // 檢查 CurrentItemStatus
    func itemReadyToPlay(_ status: AVPlayerItem.Status?) {
        currentPlayingItemStatus = status ?? .unknown
    }
    // 更新播放進度
    func updateItemProgress(currentDuration: Float64, totalDuration: Float64) {
        if currentDuration == totalDuration {
            playNextEP?()
        } else {
            let value = Float(currentDuration / totalDuration)
            trackDuration?(value)
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

extension AVPlayerController: EpisodeSoundLoader {
    public func load(with soundURL: URL) {
        let asset = AVAsset(url: soundURL)
        let playerItem = AVPlayerItem(asset: asset)
                
        if player?.currentItem == nil {
            player = AVPlayer(playerItem: playerItem)
            addObserver()
        } else {
            pause()
            player?.replaceCurrentItem(with: playerItem)
        }
        
        trackDuration?(0)
        play()
    }
}
