//
//  SceneDelegate.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/25/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var navigationController = makeNavigationController()
    lazy var coordinator = PodcastFeedCoordinator(navigationController: navigationController,
                                                  makeHomepageViewController: makeRootViewController())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        coordinator.start()
    }
    
    private func makeRootViewController() -> UIViewController {
        return PodcastFeedViewControllerFactory.makeHomepageViewController(url: URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!)
    }
    
    private func makeNavigationController() -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.tintColor = .black
        return nav
    }
}

