//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit
import AVFoundation

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
        firstTimeLoadEpisode()
        // # 初始化 Player 的設定1
        configurePlayer()
        trackDuration()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
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
            modelController?.getEpisode(type: .next, completion: { [weak self] (result) in
                switch result {
                case let .success((episode, url)):
                    self?.loadEpisode(with: episode)
                    self?.delegate?.load(with: url)
                    self?.playerState = .playing
                    self?.playButton.setImage(UIImage.pauseHollow, for: .normal)
                case let .failure(error):
                    self?.handleError(withError: error, state: .next)
                }
            })
        case previousEPButton:
            modelController?.getEpisode(type: .previous, completion: { [weak self] (result) in
                switch result {
                case let .success((episode, url)):
                    self?.loadEpisode(with: episode)
                    self?.delegate?.load(with: url)
                    self?.playerState = .playing
                    self?.playButton.setImage(UIImage.pauseHollow, for: .normal)
                case let .failure(error):
                    self?.handleError(withError: error, state: .previous)
                }
            })
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
    
    func firstTimeLoadEpisode() {
        modelController?.getEpisode(type: .current, completion: { [weak self] (result) in
            switch result {
            case let .success((episode, _)):
                self?.loadEpisode(with: episode)
            case let .failure(error):
                self?.handleError(withError: error, state: .current)
            }
        })
    }
    
    func loadEpisode(with episode: Episode?) {
        guard let episode = episode else {
            handleError(withError: PlayerModelController.Error.indexOutOfRange, state: .current)
            return
        }
        
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func configurePlayer() {
        delegate = player
        
        modelController?.getEpisode(type: .current, completion: { [weak self] (result) in
            switch result {
            case let .success((_, url)):
                self?.delegate?.load(with: url)
            default:
                break
            }
        })
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (current, total) in
            let value = current / total
            self?.slider.value = Float(value)
        }
        
        player?.askForNextEP = { [weak self] in
            self?.modelController?.getEpisode(type: .next, completion: { (result) in
                switch result {
                case let .success((episode, url)):
                    self?.delegate?.load(with: url)
                    self?.loadEpisode(with: episode)
                case let .failure(error):
                    self?.handleError(withError: error, state: .next)
                }
            })
        }
    }
    
    //MARK: Handle Slide Change:
    @objc func handleSlideChange() {
        let value = slider.value
        
        delegate?.update(episodeCurrentDurationWith: value)
    }
}

private extension PlayerViewController {
    func handleError(withError errorType: PlayerModelController.Error, state: PlayerModelController.EpisodeType) {
        switch errorType {
        case .indexOutOfRange:
            switch state {
            case .next:
                popAlert(title: "提醒", message: "這首已經是最新的 Podcast 了", actionTitle: "確認")
            case .previous:
                popAlert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actionTitle: "確認")
            default:
                popAlert(title: "提醒", message: "當前的 Podcast 出現異常", actionTitle: "確認")
            }
            
            playButton.setImage(UIImage.playHollow, for: .normal)
        case .noSoundURL:
            popAlert(title: "錯誤", message: "音檔缺失", actionTitle: "確認")
            playButton.setImage(UIImage.playHollow, for: .normal)
        }
        
        delegate?.pause()
        playerState = .stopped
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
