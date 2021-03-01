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
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func render(with model: EpisodeFeedCellViewModel) {
        titleLabel.text = model.title
        
        publishedDataLabel.text = model.date
        
        episodeImageView.kf.setImage(
            with: model.imageURL,
            placeholder: UIImage(named: "placeholderImage"))
    }
}

extension EpisodeFeedCellViewModel {
    static func configure(with models: [RSSItem], at indexPath: IndexPath) -> EpisodeFeedCellViewModel {
        let title: String?
        let date: String?
        let imageURL: URL
        
        let model = models[indexPath.row]
        
        title = model.title
        
        if let receivedDate = model.pubDate {
            date = DateFormatter.getDateString(with: receivedDate, dateType: .yearMonthDay)
        } else {
            date = "Unknown"
        }
       
        imageURL = URL(string: "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg")!
        
        return EpisodeFeedCellViewModel(title: title,
                                        date: date,
                                        imageURL: imageURL)
    }
}
