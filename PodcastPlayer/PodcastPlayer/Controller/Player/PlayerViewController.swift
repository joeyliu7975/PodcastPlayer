//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

public final class PlayerModelController {
    private(set) var episodes:[Episode] = []
    private(set) var currentIndex: Int
    
    var soundURL: URL? {
        return getCurrentEpisode().soundURL
    }
    
     var previousIndex: Int {
        return currentIndex - 1
    }
    
    var nextIndex: Int {
        return currentIndex + 1
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
    
    private var player: AudioPlayerController?
    private var modelController: PlayerModelController?
    
    private(set) var isPlaying: Bool = false 
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.layer.cornerRadius = playButton.frame.height / 2
            playButton.layer.borderColor = UIColor.systemBlue.cgColor
            playButton.layer.borderWidth = 2.0
        }
    }
    @IBOutlet weak var nextEPButton: UIButton!
    @IBOutlet weak var previousEPButton: UIButton!
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.minimumValue = 0
            slider.value = 0
            slider.maximumValue = 1
        }
    }
    
    convenience init(player: AudioPlayerController, episodes: [Episode], currentIndex: Int) {
        self.init()
        self.player = player
        self.modelController = PlayerModelController(episodes: episodes, currentIndex: currentIndex)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // # 初始化 Player 的設定1
        configurePlayer()
        trackDuration()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        guard let _ = modelController else { return }
        
        switch sender {
        case playButton:
            if isPlaying {
                playButton.setImage(UIImage(named: "pause_hollow"), for: .normal)
                player?.play()
            } else {
                playButton.setImage(UIImage(named: "custom_play_hollow"), for: .normal)
                player?.pause()
            }
            
            isPlaying.toggle()
        case nextEPButton:
            break
        case previousEPButton:
            break
        default:
            break
        }
    }
    
    @IBAction func drag(_ sender: UISlider) {}
    
}

extension PlayerViewController {
    func setup() {
        nextEPButton.contentMode = .center
        previousEPButton.contentMode = .center
        
        guard let model = modelController else { return }
        
        let episode = model.getCurrentEpisode()
        
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func configurePlayer() {
        guard let url = modelController?.soundURL else { return }
        
        player?.url = url
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (current, total) in
            let value = current / total
            self?.slider.value = Float(value)
        }
    }
}

extension PlayerViewController {
    
}
