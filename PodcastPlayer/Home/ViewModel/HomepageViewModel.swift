//
//  HomepageViewModel.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/12/21.
//

import Foundation

public final class HomepageViewModel {
    
    private var loader: EpisodeFeedLoader?
    
    public var configureHeaderView: ((URL) -> Void)?
    public var refreshData: (() -> Void)?
    public var handleError: ((Error) -> Void)?
    
    public init(loader:EpisodeFeedLoader) {
        self.loader = loader
    }
    
    public private(set) var feed: ChannelFeed? {
        didSet {
            if let feed = feed, let imageURL = feed.profileImage {
                self.configureHeaderView?(imageURL)
            }
            
            refreshData?()
        }
    }
    
    public func load() {
        loader?.load(completion: { [weak self] (result) in
            switch result {
            case let .success(channelFeeds):
                    self?.feed = channelFeeds
            case let .failure(error):
                self?.handleError?(error)
            }
        })
    }
    
    public func getEpisode(at index: Int) throws -> Episode {
        if let episode = feed?.episodes[index] as? Episode {
            
            let dateString = DateformatterHelper.shared.convertDateFrom(string: episode.releaseDate, from: .detail)
            
            episode.releaseDate = dateString

            return episode
        }
        
        throw NSError(domain: "Index out of range", code: 1)
    }
}
