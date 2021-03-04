//
//  UIViewController+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import UIKit

extension UIViewController {
    func popAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
