//
//  EpisodeFeedLoader.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import Foundation
import AlamofireRSSParser

public protocol EpisodeFeedLoader {
    typealias Result = Swift.Result<RSSFeed, Error>
    
    func load(completion: (Result) -> Void)
}
