//
//  HomepageTableHeaderView.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import UIKit
import Kingfisher

class HomepageTableHeaderView: UIView {

    let imageView = UIImageView(frame: .zero)

       override init(frame: CGRect) {
           super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "homepageChannel_Image")
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
           NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
               ])
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configure(with url: URL) {
        
    }

}
