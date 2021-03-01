//
//  EpisodeFeedTableViewCell.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import UIKit

public final class EpisodeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDataLabel: UILabel!
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func render(with model: Episode) {
        titleLabel.text = model.title
        
        publishedDataLabel.text = model.releaseDate
        
        episodeImageView.kf.setImage(
            with: model.coverImage,
            placeholder: UIImage.placeholder)
    }
}
