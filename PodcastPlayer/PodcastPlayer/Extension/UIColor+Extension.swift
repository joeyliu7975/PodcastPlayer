//
//  UIColor+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/3/21.
//

import UIKit

extension UIColor {
    
    public static let kkBlue: UIColor = makeColor(r: 100, g: 211, b: 236)
    
    private static func makeColor(r:CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
}
