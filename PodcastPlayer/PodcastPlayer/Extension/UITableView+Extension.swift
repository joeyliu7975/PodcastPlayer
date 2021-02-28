//
//  UITableView+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import UIKit

extension UITableView {
    func register(with id: String) {
        let nib = UINib(nibName: id, bundle: nil)
        self.register(nib, forCellReuseIdentifier: id)
    }
}

