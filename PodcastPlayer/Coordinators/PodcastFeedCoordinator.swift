//
//  PodcastFeedCoordinator.swift
//  PodcastPlayer
//
//  Created by JiaSin Liu on 2023/2/22.
//

import UIKit

final class PodcastFeedCoordinator: Coordinating {
    
    typealias MakeHomeViewController = (URL, @escaping (([Episode], Int) -> Void)) -> UIViewController
    private let navigationViewController: UINavigationController
    private let makeHomeViewController: MakeHomeViewController
    private let homePageUrl: URL
    
    init(navigationController: UINavigationController,
         makeHomepageViewController: @escaping MakeHomeViewController,
         homePageUrl: URL) {
        self.navigationViewController = navigationController
        self.makeHomeViewController = makeHomepageViewController
        self.homePageUrl = homePageUrl
    }
    
    func start() {
        navigationViewController.setViewControllers([
            makeHomeViewController(homePageUrl) { [weak self] episodes, index in
            self?.tapOnEpisode(episodes: episodes, currentPage: index)
        }], animated: false)
    }
    
    func tapOnEpisode(episodes: [Episode], currentPage: Int) {
        let episodeViewController = PodcastFeedViewControllerFactory.makeEpisodePageViewController(episodes: episodes,
                                                                                                   currenPage: currentPage)
        navigationViewController.pushViewController(episodeViewController, animated: true)
    }
}

