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
    
//    private var episodes:[Episode] = []
//    private var currentIndex: Int?
    
    private var url: URL? {
        let episode = modelController?.getCurrentEpisode()
        return episode?.soundURL
//        guard let index = modelController?.currentIndex,
//              let url = modelController?.episodes[index].soundURL else { return nil }
        
//        return url
    }
    
    private(set) var isPlaying: Bool = false
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
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
        
//        self.episodes = episodes
//        self.currentIndex = currentIndex
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // # 初始化 Player 的設定1
        configurePlayer()
        trackDuration()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        guard let model = modelController else { return }
        
        switch sender {
        case playButton:
            if isPlaying {
                player?.play()
            } else {
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
//        guard let index = currentIndex else { return }
        guard let model = modelController else { return }
        
        let episode = model.getCurrentEpisode()
        
        episodeImageView.kf.setImage(with: episode.coverImage)
        episodeLabel.text = episode.title
    }
    
    func configurePlayer() {
        guard let url = url else { return }
        
        player?.url = url
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (current, total) in
            let value = current / total
            self?.slider.value = Float(value)
        }
    }
}
