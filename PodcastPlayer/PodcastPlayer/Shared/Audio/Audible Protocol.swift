//
//  Audible Protocol.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/3/21.
//

import Foundation

public protocol Audible {
    
}

public protocol PlayPauseProtocol {
    func play()
    func pause()
    
    var notify: ((Bool) -> Void)? { get set }
}
// MARK:- Episode 單集控制
public protocol EpisodeProgressTracking {
    func update(episodeCurrentDurationWith value: Float)
    
//    var trackDuration: ((Float64, Float64) -> Void)? { get set }
    var trackDuration: ((Float) -> Void)? { get set }
}

// Audio 進度調整和前一集、下一集
public protocol EpisodeSoundLoader {
    func load(with soundURL: URL) 
    var playNextEP:(() -> Void)? { get set }
}
