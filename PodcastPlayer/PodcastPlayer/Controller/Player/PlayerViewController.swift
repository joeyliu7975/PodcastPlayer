//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import Kingfisher

public final class PlayerViewController: UIViewController {

    typealias TouchEvent = PlayerModelController.EventType
    
    private var player: AudioPlayerController?
    private var modelController: PlayerModelController?
    private var currentEpisode: Episode?
    
    var update: ((Episode) -> Void)?
    
    fileprivate var playerState: PlayerState = .playing {
        didSet {
            if playerState == .playing {
                playButton.setImage(UIImage.pauseHollow, for: .normal)
                player?.play()
            } else {
                playButton.setImage(UIImage.playHollow, for: .normal)
                player?.pause()
            }
        }
    }
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextEPButton: UIButton!
    @IBOutlet weak var previousEPButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    convenience init(player: AudioPlayerController = AudioPlayerController(), episodes: [Episode], currentIndex: Int) {
        self.init()
        self.player = player
        self.modelController = PlayerModelController(episodes: episodes, currentIndex: currentIndex)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configurePlayer()
        trackDuration()
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
        loadEpisode(event:.checkNextEP)
    }
    
    @IBAction func pressPreviousEP(_ sender: UIButton) {
        loadEpisode(event: .checkPreviousEP)
    }

    deinit {
        player?.resetPlayer()
    }
}

extension PlayerViewController {
    func renderInterface(with episode: Episode) {
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (current, total) in
            let value = current / total
            self?.slider.value = Float(value)
        }
        
        player?.playNextEP = { [weak self] in
            self?.loadEpisode(event: .checkNextEP)
        }
        
        player?.updateProgress = { [weak self] readyToPlay in
            guard let self = self else { return }
            
            self.playerState = readyToPlay ? .playing : .stopped
        }
    }
    
    //MARK: Handle Slide Change:
    @objc func handleSlideChange() {
        player?.update(episodeCurrentDurationWith: slider.value)
    }
    
    @objc func slideIsDragging() {
        playerState = .stopped
        player?.pause()
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
        
    func configurePlayer() {
        loadEpisode(event:.checkCurrentEP)
    }
}
   //MARK: Episode Loading:
extension PlayerViewController {
    // #1. Get the right episode and soundURL from Model Layer
    func loadEpisode(event: TouchEvent) {
        modelController?.getEpisode(type: event, completion: { [weak self] (result) in
            switch result {
            case let .success((episode, url)):
                self?.handle(event: event, episode: episode, url: url)
            case let .failure(error):
                self?.showAlert(with: error, event: event)
                self?.playerState = .stopped
            }
        })
    }
    // #2. Handle episode and url depends on user's touchEvent
    func handle(event: TouchEvent, episode: Episode, url: URL)  {
        switch event {
        case .checkCurrentEP:
            renderInterface(with: episode)
            player?.load(with: url)
        default:
            changeEpisode(episode: episode, url: url)
        }
    }
    // #3. Change podcast url
    func changeEpisode(episode: Episode, url: URL) {
        renderInterface(with: episode)
        currentEpisode = episode
        player?.replace(url: url)
        playerState = .playing
    }
}

// MARK: Handle Alert event
private extension PlayerViewController {
    func showAlert(with error: PlayerModelController.Error, event: PlayerModelController.EventType) {
        guard error != .noSoundURL else {
            self.popAlert(title: "提醒", message: "無法讀取音檔", actionTitle: "確認")
            return
        }
        
        switch event {
        case .checkCurrentEP:
            popAlert(title: "提醒", message: "當集 Podcast 讀取失敗", actionTitle: "確認")
        case .checkNextEP:
            popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actionTitle: "確認")
        case .checkPreviousEP:
            popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actionTitle: "確認")
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
