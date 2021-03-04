//
//  EpisodeFeedLoader.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public protocol EpisodeFeedLoader {
    typealias Result = Swift.Result<ChannelFeed, Error>
    
    func load(completion: @escaping (Result) -> Void)
}
