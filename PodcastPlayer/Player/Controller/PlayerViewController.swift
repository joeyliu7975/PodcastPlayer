//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import Kingfisher

public final class PlayerViewController: UIViewController {

    public typealias AudioPlayable = (PlayPauseProtocol & EpisodeProgressTracking & EpisodeSoundLoader)
    public var updateEpisode: ((Episode) -> Void)?
    private var viewModel: PlayerViewModel?
    private var audioPlayer: AudioPlayable?
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet weak var nextEPButton: UIButton!
    @IBOutlet weak var previousEPButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    public convenience init(audioPlayer: AudioPlayable = AVPlayerManager(), playerModel: EpisodeManipulatible) {
        self.init()
        self.audioPlayer = audioPlayer
        self.viewModel = PlayerViewModel(model: playerModel)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModelBinding()
        loadEpisodeForFirstTime()
        trackAudio()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let episode = viewModel?.currentEpisode else { return }
        
        updateEpisode?(episode)
        audioPlayer?.resetPlayer()
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        viewModel?.togglePlayState()
    }
    
    @IBAction func pressNextEP(_ sender: UIButton) {
        viewModel?.loadEpisode(event:.checkNextProject)
    }
    
    @IBAction func pressPreviousEP(_ sender: UIButton) {
        viewModel?.loadEpisode(event: .checkPreviousProject)
    }
}
// MARK: AVPlayerManager's callback
extension PlayerViewController {
    private func trackAudio() {
        audioPlayer?.trackDuration = { [weak self] (value) in
            self?.slider.value = Float(value)
        }
        
        audioPlayer?.playNextProject = { [weak self] in
            self?.viewModel?.loadEpisode(event: .checkNextProject)
        }
        
        audioPlayer?.notifyPlayerStatus = { [weak self] readyToPlay in
            self?.viewModel?.updatePlayState(readyToPlay: readyToPlay)
        }
        
        audioPlayer?.loadingFailed = { [weak self] in
            self?.viewModel?.handleError(error: .noSoundURL)
        }
    }
}

// MARK: UI Components setup
private extension PlayerViewController {
    func setup() {
        playButton.tintColor = .kkBlue
        playButton.layer.cornerRadius = playButton.frame.height / 2
        playButton.layer.borderColor = UIColor.kkBlue.cgColor
        playButton.layer.borderWidth = 2.0
        playButton.imageEdgeInsets = UIEdgeInsets(top: 30,left: 30,bottom: 30,right: 30)
        
        nextEPButton.imageView?.tintColor = .kkBlue
        previousEPButton.imageView?.tintColor = .kkBlue
        
        slider.tintColor = .kkBlue
        slider.thumbTintColor = .kkBlue
        slider.minimumValue = 0
        slider.value = 0
        slider.maximumValue = 1
        
        slider.addTarget(self, action: #selector(handleSlideChange), for: .touchUpInside)
        slider.addTarget(self, action: #selector(slideIsDragging), for: .valueChanged)
    }
    // Render Episode Cover Image and Title
   func renderInterface(with episode: Episode) {
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    // Load Episode
    func loadEpisodeForFirstTime() {
        viewModel?.loadEpisode(event:.checkCurrentProject)
    }
    
    // Handle Slider's Action
    @objc func handleSlideChange() {
        audioPlayer?.updateCurrentDuration(with: slider.value)
    }
    
    @objc func slideIsDragging() {
        viewModel?.updatePlayState(to: .stopped)
        audioPlayer?.pause()
    }
}
   //MARK: ViewModel Binding:
extension PlayerViewController {
    func viewModelBinding() {
        viewModel?.reload = { [weak self] (episode, url) in
            self?.renderInterface(with: episode)
            self?.audioPlayer?.load(with: url)
        }
        
        viewModel?.playAudio = { [weak self] in
            self?.playButton.setImage(UIImage.pauseHollow, for: .normal)
            self?.audioPlayer?.play()
        }
        
        viewModel?.pauseAudio = { [weak self] in
            self?.playButton.setImage(UIImage.playHollow, for: .normal)
            self?.audioPlayer?.pause()
        }
        
        viewModel?.failOnLoadingSoundtrack = { [weak self] in
            let actions = self?.alertActions(with: .noSoundURL)
            self?.popAlert(title: "提醒", message: "無法讀取音檔", actions: actions!)
        }
        
        viewModel?.cannotFindEpisode = { [weak self] (event) in
            let actions = self?.alertActions(with: .indexOutOfRange)
            
            switch event {
            case .checkCurrentProject:
                self?.popAlert(title: "提醒", message: "當集 Podcast 讀取失敗", actions: actions!)
            case .checkNextProject:
                self?.popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actions: actions!)
            case .checkPreviousProject:
                self?.popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actions: actions!)
            }
        }
    }
}

// MARK: Alert Handler
private extension PlayerViewController {
    func alertActions(with error: PlayerModel.Error) -> [UIAlertAction] {
        var alertAction: UIAlertAction
        
        switch error {
        case .noSoundURL:
            alertAction = UIAlertAction(title: "確認", style: .default) { [weak self] (_) in
                self?.dismiss(animated: true)
            }
        case .indexOutOfRange:
            alertAction = UIAlertAction(title: "確認", style: .default)
        }
           
        return [alertAction]
    }
}
