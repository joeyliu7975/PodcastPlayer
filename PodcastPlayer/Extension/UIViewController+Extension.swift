//
//  UIViewController+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import UIKit

extension UIViewController {
    func popAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}
