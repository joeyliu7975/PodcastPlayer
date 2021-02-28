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
    
    //let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeFeedTableViewCell.reuseID, for: indexPath) as! EpisodeFeedTableViewCell
    
    func makeCell<Cell: UITableViewCell>(with reuseID: String, for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? Cell else {
            fatalError("The declared reusable cell doesn't exist!")
        }
        
        return cell
    }
}

