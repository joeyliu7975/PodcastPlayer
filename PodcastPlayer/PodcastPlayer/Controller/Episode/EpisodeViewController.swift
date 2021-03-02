//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import AVKit

public final class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        
        let url = URL(string: "https://feeds.soundcloud.com/stream/921421315-daodutech-ep119-stripe.mp3")!
        
        let playerVC  = PlayerViewController(player: .shared, url: url)
                        
        self.navigationController?.pushViewController(playerVC, animated: true)
    }
    
}

private extension EpisodeViewController {
    func setup() {
        playButton.layer.borderColor = UIColor.systemBlue.cgColor
        playButton.layer.borderWidth = 15.0
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }
}
