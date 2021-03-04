//
//  Audible Protocol.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/3/21.
//

import Foundation

public protocol PlayPauseProtocol: AnyObject {
    func play()
    func pause()
}
// MARK:- Episode 單集控制
public protocol EpisodeProgressTracking: AnyObject {
    func update(episodeCurrentDurationWith value: Float)
}

// Audio 進度調整和前一集、下一集
public protocol Controllable: AnyObject {
    typealias EpisodeInfo = (Episode, Int)
    typealias Completion = (EpisodeInfo) -> Void
    
    func progressControl(value: Float)
    func nextEp(currentEpisode: EpisodeInfo, completion: Completion)
    func previousEp(currentEpisode: EpisodeInfo, completion: Completion)
}
