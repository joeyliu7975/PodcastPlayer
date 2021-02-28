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

        setup()
        sendRequest()
    }
}

extension HomepageViewController {
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(with: EpisodeFeedTableViewCell.reuseID)
    }
    
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

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feed = self.feed else { return 0 }
        
        return feed.items.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeFeedTableViewCell = tableView.makeCell(with: EpisodeFeedTableViewCell.reuseID, for: indexPath)
        
        guard let cellModel = feed?.items[indexPath.row] else { return cell }
        
        cell.configure(with: cellModel)
        
        return cell
    }
}

