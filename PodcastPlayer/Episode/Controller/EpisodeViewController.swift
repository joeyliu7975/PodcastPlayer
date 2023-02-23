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
    
    private let updateEpisode: ([Episode], Int, @escaping (Episode) -> Void) -> Void
    private var viewModel: EpisodeViewModel?
    
    init(episodes: [Episode],
         currentEpisodeIndex: Int,
         onTapPaly: @escaping ([Episode], Int, @escaping (Episode) -> Void) -> Void) {
        self.viewModel = EpisodeViewModel(epiosdes: episodes, at: currentEpisodeIndex)
        self.updateEpisode = onTapPaly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        viewModelBinding()
        configure()
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        guard let episodes = viewModel?.episodes, let index = viewModel?.currentEpisodeIndex else { return }
        updateEpisode(episodes, index) { [viewModel] (episode) in
            viewModel?.update(episode: episode)
        }
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
