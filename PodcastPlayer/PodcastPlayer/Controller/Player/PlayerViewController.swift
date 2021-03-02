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
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fastforwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    
    convenience init(player: AudioPlayerController, episodes: [Episode], currentIndex: Int) {
        self.init()
        self.player = player
        self.episodes = episodes
        self.currentIndex = currentIndex
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configure()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case playButton:
            player?.play()
        case fastforwardButton:
            player?.forwardVideo()
        case rewindButton:
            player?.rewindVideo()
        default:
            break
        }
    }
}

extension PlayerViewController {
    private func configure() {
        guard let url = url else { return }
        player?.configure(with: url)
    }
}
