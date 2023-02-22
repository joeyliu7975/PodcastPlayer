//
//  PodcastFeedViewControllerFactory.swift
//  PodcastPlayer
//
//  Created by JiaSin Liu on 2023/2/22.
//

import UIKit

class PodcastFeedViewControllerFactory {
    
    static func makeHomepageViewController() -> UIViewController {
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        let remoteFeedLoader = RemoteEpisodeFeedLoader(client: URLSessionHTTPClient(), url: url)
        let homeViewController = HomepageViewController(loader: remoteFeedLoader)
        return homeViewController
    }
}
