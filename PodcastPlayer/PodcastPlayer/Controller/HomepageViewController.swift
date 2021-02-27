//
//  HomepageViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import UIKit
import Alamofire

public final class HomepageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var loader: EpisodeFeedLoader?
    
    public convenience init(loader: EpisodeFeedLoader = AlamofireEpisodeFeedLoader()){
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        callAPI()
    }
}

private extension HomepageViewController {
    func callAPI() {
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        
        loader?.load(url: url, completion: { (result) in
            switch result {
            case let .success(feeds):
                print(feeds)
            case let .failure(error):
                print(error)
            }
        })
    }
}
