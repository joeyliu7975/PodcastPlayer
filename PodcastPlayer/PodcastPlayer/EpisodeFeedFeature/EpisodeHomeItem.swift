//
//  RSSItem.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import Foundation

public struct Episode: Equatable {
    var coverImage: URL?
    var title = String()
    var releaseDate = String()
}

public struct ChannelFeed: Equatable {
    var episodes: [Episode] = []
    var profileImage: URL?
}
