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
                                                                                                   currenPage: currentPage,
                                                                                                   onTapPlay: { [weak self] (episodes, page, playingEpisode) in
            self?.tapOnPlay(episodes: episodes, currentPage: page, playingEpisode: playingEpisode)
        })
        navigationViewController.pushViewController(episodeViewController, animated: true)
    }
    
    func tapOnPlay(episodes: [Episode],
                   currentPage: Int,
                   playingEpisode: @escaping (Episode) -> Void) {
        let playerVC = PodcastFeedViewControllerFactory.makePlayerViewController(episodes: episodes,
                                                                                 currentPage: currentPage,
                                                                                 updateEpisode: playingEpisode,
                                                                                 failOnLoadingSoundtrack: failOnLoadingSoundtrack) { [weak self] event in
            self?.cannotFindEpisode(event: event)
        }
        
        navigationViewController.present(playerVC, animated: true)
    }
    
    private func failOnLoadingSoundtrack() {
        let actions = alertActions(with: .noSoundURL)
        navigationViewController.presentedViewController?.popAlert(title: "提醒", message: "無法讀取音檔", actions: actions)
    }
    
    private func cannotFindEpisode(event: PlayerViewController.TouchEvent) {
        let actions = alertActions(with: .indexOutOfRange)
        let viewController = navigationViewController.presentedViewController
        
        switch event {
        case .checkCurrentProject:
            viewController?.popAlert(title: "提醒", message: "當集 Podcast 讀取失敗", actions: actions)
        case .checkNextProject:
            viewController?.popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actions: actions)
        case .checkPreviousProject:
            viewController?.popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actions: actions)
        }
    }
    
    //MARK: AlertAction
    private func alertActions(with error: PlayerModel.Error) -> [UIAlertAction] {
        var alertAction: UIAlertAction
        
        switch error {
        case .noSoundURL:
            alertAction = UIAlertAction(title: "確認", style: .default) { [weak navigationViewController] (_) in
                navigationViewController?.topViewController?.dismiss(animated: true)
            }
        case .indexOutOfRange:
            alertAction = UIAlertAction(title: "確認", style: .default)
        }
           
        return [alertAction]
    }
}

