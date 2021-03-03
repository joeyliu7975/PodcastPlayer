//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

public final class PlayerViewController: UIViewController {
    
    private var player: AudioPlayerController?
    
    private var episodes:[Episode] = []
    private var currentIndex: Int?
    
    private var url: URL? {
        guard let index = currentIndex,
              let url = episodes[index].soundURL else { return nil }
        
        return url
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
        self.episodes = episodes
        self.currentIndex = currentIndex
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // # 初始化 Player 的設定1
        configure()
        trackDuration()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case playButton:
            if isPlaying {
                player?.play()
            } else {
                player?.pause()
            }
            
            isPlaying.toggle()
        case nextEPButton:
            guard let index = currentIndex else { return }
            
            let nextIndex = index + 1
            
            if episodes.indices.contains(nextIndex) {
                player?.previousEp(currentEpisode: (episodes[index], index), completion: { (episode, index) in
                    
                })
                
                isPlaying = true
            }
        case previousEPButton:
            guard let index = currentIndex else { return }
            
            let previousIndex = index - 1
            
            if episodes.indices.contains(previousIndex) {
                player?.previousEp(currentEpisode: (episodes[index], index), completion: { (episode, index) in
                    
                })
                
                isPlaying = true
            }
        default:
            break
        }
    }
    
    @IBAction func drag(_ sender: UISlider) {}
    
}

extension PlayerViewController {
    func configure() {
        guard let url = url else { return }
        player?.url = url
    }
    
    func trackDuration() {
        player?.trackDuration = { [weak self] (duration) in
            let duration = Float(duration)
            print(duration)
        }
    }
}
