//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import AVFoundation

public final class PlayerModelController {
    private(set) var episodes:[Episode] = []
    
    var currentIndex: Int
    
    var soundURL: URL? {
        return getCurrentEpisode().soundURL
    }
    
     var previousIndex: Int {
        return currentIndex + 1
    }
    
    var nextIndex: Int {
        return currentIndex - 1
    }
    
    init(episodes:[Episode], currentIndex: Int) {
        self.episodes = episodes
        self.currentIndex = currentIndex
    }
    
    public enum Error: Swift.Error {
        case indexOutOfRange
    }
    
    func getCurrentEpisode() -> Episode {
        return episodes[currentIndex]
    }
}

public final class PlayerViewController: UIViewController {
    
    typealias Audible = (PlayPauseProtocol & EpisodeProgressTracking & EpisodeSoundLoader)
    
    private weak var player: AudioPlayerController?
    private var modelController: PlayerModelController?
    
    weak var delegate: Audible?
    
    fileprivate var playerState: PlayerState = .playing
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextEPButton: UIButton!
    @IBOutlet weak var previousEPButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    convenience init(player: AudioPlayerController = .shared, episodes: [Episode], currentIndex: Int) {
        self.init()
        self.player = player
        self.modelController = PlayerModelController(episodes: episodes, currentIndex: currentIndex)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadEpisode(with: modelController?.getCurrentEpisode())
        // # 初始化 Player 的設定1
        configurePlayer()
        trackDuration()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        guard let _ = modelController else { return }
        
        switch sender {
        case playButton:
            playerState.toggle()
            
            switch playerState {
            case .playing:
                playButton.setImage(UIImage.pauseHollow, for: .normal)
                delegate?.play()
            case .stopped:
                playButton.setImage(UIImage.playHollow, for: .normal)
                delegate?.pause()
            }
            
        case nextEPButton:
            guard let model = modelController else { return }
            
            let nextIndex = model.nextIndex
            
            if model.episodes.indices.contains(nextIndex) {
                // 改變目前的 currentIndex
                model.currentIndex -= 1
                
                let url = model.getCurrentEpisode().soundURL!

                delegate?.load(with: url)

                loadEpisode(with: model.getCurrentEpisode())
                
                self.playerState = .playing
                
                self.playButton.setImage(UIImage.pauseHollow, for: .normal)
            } else {
                popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actionTitle: "確認")
            }
        case previousEPButton:
            guard let model = modelController else { return }
            
            let previousIndex = model.previousIndex
            
            if model.episodes.indices.contains(previousIndex) {
                // 改變目前的 currentIndex
                model.currentIndex += 1
                
                let url = model.getCurrentEpisode().soundURL!
                
                delegate?.load(with: url)
                
                loadEpisode(with: model.getCurrentEpisode())
                
                self.playerState = .playing
                
                self.playButton.setImage(UIImage.pauseHollow, for: .normal)
            } else {
                popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actionTitle: "確認")
            }
        default:
            break
        }
    }
    
    deinit {
        delegate?.pause()
    }
}

extension PlayerViewController {
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
        slider.addTarget(self, action: #selector(handleSlideChange), for: .valueChanged)
    }
    
    func loadEpisode(with episode: Episode?) {
        guard let episode = episode else { return }
        
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func configurePlayer() {
        delegate = player
        
        guard let url = modelController?.soundURL else { return }
        
        delegate?.load(with: url)
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (current, total) in
            let value = current / total
            self?.slider.value = Float(value)
        }
        
        player?.askForNextEP = { [weak self] in
            guard let model = self?.modelController else { return }
            
            let nextIndex = model.nextIndex
            
            if model.episodes.indices.contains(nextIndex) {
                // 改變目前的 currentIndex
                model.currentIndex -= 1
                
                let url = model.getCurrentEpisode().soundURL!
                
                self?.delegate?.load(with: url)

                self?.loadEpisode(with: model.getCurrentEpisode())
            } else {
                self?.popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actionTitle: "確認")
                self?.playButton.setImage(UIImage.playHollow, for: .normal)
                
                self?.playerState = .stopped
            }
        }
    }
    
    //MARK: Handle Slide Change:
    @objc func handleSlideChange() {
        let value = slider.value
        
        delegate?.update(episodeCurrentDurationWith: value)
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
