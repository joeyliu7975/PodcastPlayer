//
//  EpisodeFeedTableViewCell.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import UIKit
import AlamofireRSSParser
import Alamofire

public final class EpisodeFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDataLabel: UILabel!
    
    static let reuseID = String(describing: EpisodeFeedTableViewCell.self)
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with model: RSSItem) {
        titleLabel.text = model.title
        
        if let date = model.pubDate {
            publishedDataLabel.text = DateFormatter.getDateString(with: date, dateType: .yearMonthDay)
        } else {
            publishedDataLabel.text = "Unknown"
        }
        
        let url = URL(string: "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")!
        
        episodeImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])    }
}
