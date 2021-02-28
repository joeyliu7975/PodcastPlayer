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
        
    }
}
