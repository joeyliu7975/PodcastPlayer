//
//  PodcastFeedCoordinator.swift
//  PodcastPlayer
//
//  Created by JiaSin Liu on 2023/2/22.
//

import UIKit

final class PodcastFeedCoordinator: Coordinating {
    
    private let navigationViewController: UINavigationController
    private let makeHomepageViewController: UIViewController
    
    init(navigationController: UINavigationController,
         makeHomepageViewController: UIViewController) {
        self.navigationViewController = navigationController
        self.makeHomepageViewController = makeHomepageViewController
    }
    
    func start() {
        navigationViewController.setViewControllers([makeHomepageViewController], animated: false)
    }
}

