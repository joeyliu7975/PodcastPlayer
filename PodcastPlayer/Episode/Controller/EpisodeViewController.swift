//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import Kingfisher

public final class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.tintColor = .kkBlue
        }
    }
            
    private var episodes:[Episode] = []
    private var currentEpisodeIndex: Int?
    
    convenience init(episodes: [Episode], currentEpisodeIndex: Int) {
        self.init()
        self.episodes = episodes
        self.currentEpisodeIndex = currentEpisodeIndex
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        load(episode: episodes[currentEpisodeIndex ?? 0])
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        guard let currentIndex = currentEpisodeIndex else { return }

        let playerViewController = PlayerViewController(episodes: episodes, currentIndex: currentIndex)
        
        playerViewController.update = { [weak self] (episode) in
            if let index = self?.episodes.firstIndex(of: episode) {
                self?.currentEpisodeIndex = index
                self?.load(episode: episode)
            }
        }
                        
        present(playerViewController, animated: true)
    }
}

private extension EpisodeViewController {
    func setup() {
        playButton.layer.borderColor = UIColor.kkBlue.cgColor
        playButton.layer.borderWidth = 12.0
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }
    
    func load(episode: Episode) {
        episodeImageView.kf.setImage(with: episode.coverImage,
                                     placeholder: UIImage.placeholder,
                                     options: [
                                         .processor(DownsamplingImageProcessor(size: episodeImageView.frame.size)),
                                         .scaleFactor(UIScreen.main.scale),
                                         .cacheOriginalImage
                                     ])
        descriptionTextView.text = episode.content
    }
}
