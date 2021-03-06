//
//  HomepageViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import UIKit
import Kingfisher

public final class HomepageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var loader: EpisodeFeedLoader?
    private var viewModel: HomepageViewModel?
    
    private lazy var headerView: HomepageTableHeaderView = {
        let headerView = HomepageTableHeaderView(frame: .zero)
        
        headerView.clipsToBounds = true
        
        return headerView
    }()

    private var tableHeaderHeight: CGFloat {
        return 160.0
    }
    
    public convenience init(loader: EpisodeFeedLoader){
        self.init()
        self.viewModel = HomepageViewModel(loader: loader)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        load()
        viewModelDataBinding()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }
}

private extension HomepageViewController {
    func load() {
        viewModel?.load()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none

        tableView.register(with: EpisodeFeedTableViewCell.reuseIdentifier)
    }
    
    func viewModelDataBinding() {
        viewModel?.refreshData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.configureHeaderView = { [weak self] (imageURL) in
            DispatchQueue.main.async {
                self?.headerView.configure(with: imageURL)
            }
        }
        
        viewModel?.handleError = { [weak self] (error) in
            DispatchQueue.main.async {
                let confirmAction = UIAlertAction(title: "確認", style: .default)
                self?.popAlert(title: "錯誤", message: "\(error)", actions: [confirmAction])
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
        guard let episodes = viewModel?.feed?.episodes as? [Episode], !episodes.isEmpty else { return }
        
        let episodeViewController = EpisodeViewController(episodes: episodes, currentEpisodeIndex: indexPath.row)

        navigationController?.pushViewController(episodeViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomepageViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.feed?.episodes.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeFeedTableViewCell = tableView.makeCell(with: EpisodeFeedTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cellModel = try? viewModel?.getEpisode(at: indexPath.row) {
            cell.render(with: cellModel)
        }
        
        return cell
    }
}
