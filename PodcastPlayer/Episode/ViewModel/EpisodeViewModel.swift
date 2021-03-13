//
//  EpisodeViewModel.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/13/21.
//

import Foundation

public final class EpisodeViewModel {
    public private(set) var episodes = [Episode]()
    
    public private(set) var episodesViewModel = Box(value: Episode())
    
    public private(set) var currentEpisodeIndex: Int
    
    init(epiosdes: [Episode], at index: Int) {
        self.episodes = epiosdes
        self.currentEpisodeIndex = index
    }
    
    public func update(to newIndex: Int) {
        self.currentEpisodeIndex = newIndex
    }
    
    public func update(episode: Episode) {
        self.episodesViewModel.value = episode
    }
}
