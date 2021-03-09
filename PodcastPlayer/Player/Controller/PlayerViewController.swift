//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import Kingfisher

public final class PlayerViewController: UIViewController {

    public typealias TouchEvent = PlayerModel.EventType
    public typealias AudioPlayable = (PlayPauseProtocol & EpisodeProgressTracking & EpisodeSoundLoader)
    
    private var audioPlayer: AudioPlayable?
    private var playerModel: EpisodeManipulatible?
    private var currentEpisode: Episode?
    
    var update: ((Episode) -> Void)?
    
    fileprivate var playerState: PlayerState = .playing {
        didSet {
            let image = (playerState == .playing) ?
                UIImage.pauseHollow : UIImage.playHollow
            
            if playerState == .playing {
                audioPlayer?.play()
            } else {
                audioPlayer?.pause()
            }
            
            playButton.setImage(image, for: .normal)
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet weak var nextEPButton: UIButton!
    @IBOutlet weak var previousEPButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    public convenience init(audioPlayer: AudioPlayable = AVPlayerManager(), episodes: [Episode], currentIndex: Int) {
        self.init()
        self.audioPlayer = audioPlayer
        self.playerModel = PlayerModel(episodes: episodes, currentIndex: currentIndex)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadEpisode(event:.checkCurrentProject)
        trackAudio()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let episode = currentEpisode else { return }
        update?(episode)
    }
    
    @IBAction func pressPlay(_ sender: UIButton) {
        playerState.toggle()
    }
    
    @IBAction func pressNextEP(_ sender: UIButton) {
        loadEpisode(event:.checkNextProject)
    }
    
    @IBAction func pressPreviousEP(_ sender: UIButton) {
        loadEpisode(event: .checkPreviousProject)
    }

    deinit {
        audioPlayer?.resetPlayer()
    }
}

extension PlayerViewController {
    func renderInterface(with episode: Episode) {
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func trackAudio() {
        audioPlayer?.trackDuration = { [weak self] (value) in
            self?.slider.value = Float(value)
        }
        
        audioPlayer?.playNextProject = { [weak self] in
            self?.loadEpisode(event: .checkNextProject)
        }
        
        audioPlayer?.notifyPlayerStatus = { [weak self] readyToPlay in
            self?.playerState = readyToPlay ? .playing : .stopped
        }
        
        audioPlayer?.loadingFailed = { [weak self] in
            let dismissAction = UIAlertAction(title: "確認", style: .default) { [weak self] (_) in
                self?.dismiss(animated: true)
            }
            
            self?.popAlert(title: "錯誤", message: "無法讀取音檔", actions: [dismissAction])
        }
    }
    
    //MARK: Handle Slide Change:
    @objc func handleSlideChange() {
        audioPlayer?.updateCurrentDuration(with: slider.value)
    }
    
    @objc func slideIsDragging() {
        playerState = .stopped
        audioPlayer?.pause()
    }
}

// MARK: Function that will only trigger once in viewDidLoad
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
}
   //MARK: Episode Loading:
extension PlayerViewController {
    // #1. Get the right episode and soundURL from Model Layer
    func loadEpisode(event: TouchEvent) {
        playerModel?.getEpisode(with: event, completion: { [weak self] (result) in
            switch result {
            case let .success((episode, url)):
                self?.handle(episode: episode, url: url)
            case let .failure(error):
                self?.showAlert(with: error, event: event)
                self?.playerState = .stopped
            }
        })
    }
    
    // #2. Handle episode and url depends on user's touchEvent
    func handle(episode: Episode, url: URL)  {
        renderInterface(with: episode)
        currentEpisode = episode
        audioPlayer?.load(with: url)
    }
}

// MARK: Handle Alert event
private extension PlayerViewController {
    func alertActions(with error: PlayerModel.Error) -> [UIAlertAction] {
        guard error != .noSoundURL else {
            let dismissAction = UIAlertAction(title: "確認", style: .default) { [weak self] (_) in
                self?.dismiss(animated: true)
            }
            return [dismissAction]
        }
        let confirmAction = UIAlertAction(title: "確認", style: .default)
            
        return [confirmAction]
    }
    
    func showAlert(with error: PlayerModel.Error, event: PlayerModel.EventType) {
       let actions = alertActions(with: error)
        
        guard error != .noSoundURL else {
            self.popAlert(title: "提醒", message: "無法讀取音檔", actions: actions)
            return
        }
        
        switch event {
        case .checkCurrentProject:
            popAlert(title: "提醒", message: "當集 Podcast 讀取失敗", actions: actions)
        case .checkNextProject:
            popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actions: actions)
        case .checkPreviousProject:
            popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actions: actions)
        }
    }
}

fileprivate enum PlayerState {
    case playing
    case stopped
    
    mutating func toggle() {
        switch self {
        case .playing: self = .stopped
        case .stopped: self = .playing
        }
    }
}
