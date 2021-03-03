//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import Kingfisher
import AVFoundation

public final class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    private var episodes:[Episode] = []
    private var currentEpisodeIndex: Int?
    private var currentEpisode: Episode {
        return episodes[currentEpisodeIndex ?? 0]
    }
    
    convenience init(episodes: [Episode], currentEpisodeIndex: Int) {
        self.init()
        self.episodes = episodes
        self.currentEpisodeIndex = currentEpisodeIndex
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        load()
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        guard let currentIndex = currentEpisodeIndex else { return }
        
        let playerVC = PlayerViewController(player: .shared, episodes: episodes, currentIndex: currentIndex)
                        
        present(playerVC, animated: true)
    }
    
}

private extension EpisodeViewController {
    func setup() {
        playButton.layer.borderColor = UIColor.systemBlue.cgColor
        playButton.layer.borderWidth = 15.0
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }
    
    func load() {
        episodeImageView.kf.setImage(with: currentEpisode.coverImage)
        descriptionTextView.text = currentEpisode.description
    }
}
