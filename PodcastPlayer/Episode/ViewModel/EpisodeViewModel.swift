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
    
    public func update(episode: Episode) {
        self.episodesViewModel.value = episode
        //TODO: Update currentEpisodeIndex's method need to be refactored
        if let index = episodes.firstIndex(where: { $0.title == episode.title }),
        currentEpisodeIndex == index {
            update(to: index)
        }
    }
    
    private func update(to newIndex: Int) {
        self.currentEpisodeIndex = newIndex
    }
}
