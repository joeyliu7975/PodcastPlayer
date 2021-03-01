//
//  HomepageViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import UIKit
import Alamofire
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

    private var feed: ChannelFeed? {
        didSet {
            guard let feed = feed else { return }
            
            self.episodes = feed.episodes
            
            if let imageURL = feed.profileImage {
                self.headerView.configure(with: feed.profileImage)
            }
        }
    }
    
    private var episodes: [Episode] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var tableHeaderHeight: CGFloat {
        return 160.0
    }
    
    public convenience init(loader: EpisodeFeedLoader){
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        load()
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
    
    func load() {
        loader?.load(completion: { [weak self] (result) in
            switch result {
            case let .success(channelFeeds):
                DispatchQueue.main.async {
                    self?.feed = channelFeeds
                }
            case let .failure(error):
                print(error)
            }
        })
    }
    
    func updateHeaderViewHeight(for header: UIView?) {
        guard let header = header else { return }
        
        header.frame.size.height = tableHeaderHeight
    }
}

extension HomepageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = episodes[indexPath.row]
        
        let nav = UINavigationController(rootViewController: EpisodeViewController())
        
        nav.navigationBar.isHidden = true
        
        present(nav, animated: true)
    }
}

extension HomepageViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeFeedTableViewCell = tableView.makeCell(with: EpisodeFeedTableViewCell.reuseIdentifier, for: indexPath)
       
        let cellModel = episodes[indexPath.row]
        
        cell.render(with: cellModel)

        return cell
    }
}
