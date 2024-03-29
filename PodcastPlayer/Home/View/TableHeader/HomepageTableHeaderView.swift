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
                
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
           NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
               ])
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func configure(with url: URL?) {
        imageView.kf.setImage(with: url, placeholder: UIImage.placeholder)
    }

}
