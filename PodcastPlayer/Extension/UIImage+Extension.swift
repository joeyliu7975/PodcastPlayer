//
//  UIImage+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import UIKit

extension UIImage {
    static let placeholder = UIImage.makeImage(.placeholder)
    static let playHollow = UIImage.makeImage(.playHollow)
    static let pauseHollow = UIImage.makeImage(.pauseHollow)
    
    static func makeImage(_ type: UIImage.LocalImageType) -> UIImage {
        
        var image: UIImage?
        
        switch type {
        case .placeholder:
            image = UIImage(named: "placeholder_image")
        case .pauseHollow:
            image = UIImage(named: "pause_hollow")
        case .playHollow:
            image = UIImage(named: "play_hollow")
        }
        
        return image ?? UIImage()
    }
    
    enum LocalImageType {
       case placeholder
        case pauseHollow
        case playHollow
   }
}
