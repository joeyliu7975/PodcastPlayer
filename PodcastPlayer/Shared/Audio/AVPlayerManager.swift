//
//  AudioPlayerController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/2/21.
//

import Foundation
import AVFoundation

public final class AVPlayerManager {
    private var player:AVPlayer?
    
    private var timeObserver: Any?
        
    private var isSeekInProgress = false
    
    private var chaseTime: CMTime = .zero
    // 更新 Audio 的進度
    public var trackDuration: ((Float) -> Void)?
    // 更新播放狀態(play/pause)
    public var notifyPlayerStatus: ((Bool) -> Void)?
    // 播放下一集
    public var playNextProject:(() -> Void)?
        
    public init(){}
}

extension AVPlayerManager {
    //MARK: #1. Get total duration
    private func getTotalDuration(currentPlayingItem: AVPlayerItem?,_ completion: (Float64) -> Void) {
        guard
            let playingItem = currentPlayingItem else { return }
        
        let duration = playingItem.duration
        
        completion(CMTimeGetSeconds(duration))
    }
}

extension AVPlayerManager: PlayPauseProtocol {
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func resetPlayer() {
        removeObserver()
        player = nil
        timeObserver = nil
    }
}

extension AVPlayerManager: EpisodeProgressTracking {
    public func updateCurrentDuration(with sliderValue: Float) {
        if let duration = player?.currentItem?.duration, checkPlayerStatus() == .readyToPlay {
            let totalSecond = CMTimeGetSeconds(duration)
            
            let value = (sliderValue) * Float(totalSecond)
            
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            
            stopPlayingAndSeekSmoothlyToTime(newChaseTime: seekTime)
        }
    }
}

//MARK: Apple's solution to handle AVPlayer seekTime:
private extension AVPlayerManager {
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
        let status = checkPlayerStatus()
        
        if status == .unknown {
            // wait until item becomes ready (KVO player.currentItem.status)
        } else if status == .readyToPlay {
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
            self.notifyPlayerStatus?(!self.isSeekInProgress)
        })
    }
}

private extension AVPlayerManager {
    // MARK: #Add Observer
    func addObserver() {
        guard let player = player else { return }
        
       timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            // 更新 PlayerCurrentItem 的 Status
            let status = self?.checkPlayerStatus()
            
            if status == .readyToPlay,
               let currentItem = player.currentItem {
                
                let totalDuration = CMTimeGetSeconds(currentItem.duration)
                let currentDuration = CMTimeGetSeconds(player.currentTime())
                
                self?.updateItemProgress(currentDuration: currentDuration, totalDuration: totalDuration)
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
    
    // 檢查 CurrentItemStatus
    func checkPlayerStatus() -> AVPlayerItem.Status {
        return player?.currentItem?.status ?? .unknown
    }
    // 更新播放進度
    func updateItemProgress(currentDuration: Float64, totalDuration: Float64) {
        if currentDuration == totalDuration {
            playNextProject?()
        } else {
            let value = Float(currentDuration / totalDuration)
            trackDuration?(value)
        }
    }
}

extension AVPlayerManager: EpisodeSoundLoader {
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
