//
//  HomepageViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import UIKit
import Alamofire
import AlamofireRSSParser
import Kingfisher

public final class HomepageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            guard let tableView = tableView else { return }
            
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.tableHeaderView = headerView
            tableView.separatorStyle = .none

            tableView.register(with: EpisodeFeedTableViewCell.reuseID)
        }
    }
    
    private var loader: EpisodeFeedLoader?
    
    private lazy var headerView: HomepageTableHeaderView = {
        let headerView = HomepageTableHeaderView(frame: .zero)
        
        return headerView
    }()
    
    private var feed: RSSFeed? {
        didSet {
            guard let feed = feed else { return }
            
            self.episodeFeeds = feed.items
        }
    }
    
    private var episodeFeeds: [RSSItem] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public convenience init(loader: EpisodeFeedLoader = AlamofireEpisodeFeedLoader()){
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        sendRequest()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }
}

private extension HomepageViewController {
    func setup() {
        self.navigationItem.title = "Homepage"
    }
    
    func sendRequest() {
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        
        loader?.load(url: url, completion: { [weak self] (result) in
            switch result {
            case let .success(feed):
                self?.feed = feed
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        
        header.frame.size.height = 80
        header.clipsToBounds = true
    }
}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeFeeds.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeFeedTableViewCell = tableView.makeCell(with: EpisodeFeedTableViewCell.reuseID, for: indexPath)
        
        let cellModel = episodeFeeds[indexPath.row]
        
        cell.configure(with: cellModel)

        return cell
    }
}

