//
//  UIImage+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

extension UIImage {
    
    static let placeholder = UIImage.makeImage(.placeholder)
    
    static func makeImage(_ type: UIImage.LocalImageType) -> UIImage {
        
        var image: UIImage?
        
        switch type {
        case .placeholder:
            image = UIImage(named: "placeholder_image")
        }
        
        return image ?? UIImage()
    }
    
    enum LocalImageType {
       case placeholder
   }
}
