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
    @IBOutlet weak var playButton: UIButton!
    
    private var viewModel: EpisodeViewModel?
    
    convenience init(episodes: [Episode], currentEpisodeIndex: Int) {
        self.init()

        viewModel = EpisodeViewModel(epiosdes: episodes, at: currentEpisodeIndex)
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        viewModelBinding()
        configure()
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        guard let episodes = viewModel?.episodes, let index = viewModel?.currentEpisodeIndex else { return }
        
        let playerViewController = PodcastFeedViewControllerFactory.makePlayerViewController(episodes: episodes,
                                                                                             currentPage: index,
                                                                                             updateEpisode: { [weak viewModel] (episode) in
            viewModel?.update(episode: episode)
        })
                        
        present(playerViewController, animated: true)
    }
}

private extension EpisodeViewController {
    func setup() {
        playButton.layer.borderColor = UIColor.kkBlue.cgColor
        playButton.layer.borderWidth = 12.0
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.tintColor = .kkBlue
    }
    
    func configure() {
        guard let episodes = viewModel?.episodes,let index = viewModel?.currentEpisodeIndex else { return }
        
        let episode = episodes[index]

        viewModel?.update(episode: episode)
    }
    
    func viewModelBinding() {
        viewModel?.episodesViewModel.bind(listener: { [weak self](episode) in
            guard let episode = episode else { return }
            
            self?.load(episode: episode)
        })
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
