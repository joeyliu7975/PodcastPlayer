//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

public final class EpisodeViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
        
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
}

private extension EpisodeViewController {
    func setup() {
        playButton.layer.borderColor = UIColor.systemBlue.cgColor
        playButton.layer.borderWidth = 15.0
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }
}
