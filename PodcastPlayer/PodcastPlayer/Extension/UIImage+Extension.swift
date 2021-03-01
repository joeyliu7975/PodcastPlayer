//
//  UIImage+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

extension UIImage {
    
    static let placeholder = UIImage.make(.placeholder)
    
    static func make(_ type: UIImage.LocalImageType) -> UIImage {
        
        var image: UIImage?
        
        switch type {
        case .placeholder:
            image = UIImage(named: "placeholderImage")
        }
        
        return image ?? UIImage()
    }
    
    enum LocalImageType {
       case placeholder
   }
}