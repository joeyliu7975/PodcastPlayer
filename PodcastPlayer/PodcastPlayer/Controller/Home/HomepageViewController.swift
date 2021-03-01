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

            tableView.register(with: EpisodeFeedTableViewCell.reuseIdentifier)
        }
    }
    
    private var loader: EpisodeFeedLoader?
    
    private lazy var headerView: HomepageTableHeaderView = {
        let headerView = HomepageTableHeaderView(frame: .zero)
        
        headerView.clipsToBounds = true
        
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
    
    private var tableHeaderHeight: CGFloat {
        return 80.0
    }
    
    private var navigationTitle: String {
        return "Homepage"
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
        self.navigationItem.title = navigationTitle
        self.navigationController?.setupNavigationBar()
    }
    
    func sendRequest() {
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        
        AF.request(url).response { (response) in
            if let data = response.data {
                let xmlParser = XMLParser(data: data)
                let delegate = HomeXMLParser()
                xmlParser.delegate = delegate
                if xmlParser.parse() {
                    print(delegate.channelFeed)
                }
            }
        }
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        
        header.frame.size.height = tableHeaderHeight
    }
}

extension HomepageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = episodeFeeds[indexPath.row]
        
        let nav = UINavigationController(rootViewController: EpisodeViewController())
        
        nav.navigationBar.isHidden = true
        
        present(nav, animated: true)
    }
}

extension HomepageViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeFeeds.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeFeedTableViewCell = tableView.makeCell(with: EpisodeFeedTableViewCell.reuseIdentifier, for: indexPath)
       
        let cellModel = EpisodeFeedCellViewModel.configure(with: episodeFeeds, at: indexPath)
        
        cell.render(with: cellModel)

        return cell
    }
}
