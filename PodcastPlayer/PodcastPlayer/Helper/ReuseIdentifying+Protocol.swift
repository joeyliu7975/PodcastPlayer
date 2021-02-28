//
//  ReuseIdentifying+Protocol.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
     static var reuseIdentifier: String {
        return String(describing: Self.self)
        }
}
