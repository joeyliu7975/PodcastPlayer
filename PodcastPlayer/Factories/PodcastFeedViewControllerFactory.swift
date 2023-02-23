//
//  PodcastFeedViewControllerFactory.swift
//  PodcastPlayer
//
//  Created by JiaSin Liu on 2023/2/22.
//

import UIKit

class PodcastFeedViewControllerFactory {
    
    static func makeHomepageViewController(url: URL,
                                           tapOnEpisode: @escaping (([Episode], Int) -> Void)) -> UIViewController {
        let remoteFeedLoader = RemoteEpisodeFeedLoader(client: URLSessionHTTPClient(), url: url)
        let homeViewController = HomepageViewController(loader: remoteFeedLoader, tapOnEpisode: tapOnEpisode)
        return homeViewController
    }
    
    static func makeEpisodePageViewController(episodes: [Episode], currenPage: Int) -> UIViewController {
        let episodeViewController = EpisodeViewController(episodes: episodes,
                                                          currentEpisodeIndex: currenPage)
        return episodeViewController
    }
    
    static func makePlayerViewController(episodes: [Episode],
                                         currentPage: Int,
                                         updateEpisode: @escaping (Episode) -> Void) -> UIViewController {
        let playerModel = PlayerModel(episodes: episodes, currentIndex: currentPage)
        let playerViewController = PlayerViewController(playerModel: playerModel)
        playerViewController.updateEpisode = updateEpisode
        return playerViewController
    }
}
