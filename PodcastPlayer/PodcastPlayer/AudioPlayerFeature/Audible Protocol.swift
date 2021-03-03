//
//  Audible Protocol.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/3/21.
//

import Foundation

public protocol Playable {
    func play()
    func pause()
}
// Audio 進度調整和前一集、下一集
public protocol Controllable {
    associatedtype Number
    typealias Completion = (Episode, Int) -> Void
    
    func progressControl(value: Number)
    func nextEp(currentEpisode: Int, completion: Completion)
    func previousEp(currentEpisode: Int, completion: Completion)
}

public protocol AudioProtocol: Playable, Controllable {
    var currentEpisodeIndex: Int? { get set }
    var currentEpisode: Episode? { get set }
}
