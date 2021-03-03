//
//  Audible Protocol.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/3/21.
//

import Foundation

public protocol Playable: AnyObject {
    func play()
    func pause()
}
// Audio 進度調整和前一集、下一集
public protocol Controllable: AnyObject {
    typealias EpisodeInfo = (Episode, Int)
    typealias Completion = (EpisodeInfo) -> Void
    
    func progressControl(value: Float)
    func nextEp(currentEpisode: EpisodeInfo, completion: Completion)
    func previousEp(currentEpisode: EpisodeInfo, completion: Completion)
}
