//
//  HomepageViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import UIKit
import Alamofire
import AlamofireRSSParser

public final class HomepageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var loader: EpisodeFeedLoader?
    
    private var feed: RSSFeed?
    
    public convenience init(loader: EpisodeFeedLoader = AlamofireEpisodeFeedLoader()){
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        sendRequest()
    }
}

extension HomepageViewController {
    func sendRequest() {
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        
        loader?.load(url: url, completion: { [weak self] (result) in
            switch result {
            case let .success(feed):
                self?.feed = feed
                self?.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        })
    }
}
