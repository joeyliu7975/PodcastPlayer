//
//  PlayerModelController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public final class PlayerModelController {
    // MARK: - Episode:
    private(set) var episodes:[Episode] = []
    
    var currentIndex: Int
 
    init(episodes:[Episode], currentIndex: Int) {
        self.episodes = episodes
        self.currentIndex = currentIndex
    }
    
    public enum Error: Swift.Error {
        case indexOutOfRange
        case noSoundURL
    }
    
    public enum EpisodeType {
        case current, previous, next
    }
    
    func getEpisode(type: EpisodeType, completion: @escaping (Result<(Episode, URL), PlayerModelController.Error>) -> Void) {
        completion(checkEpisode(type: type, currentIndex: currentIndex))
    }
    
    private func checkEpisode(type: EpisodeType, currentIndex: Int) -> Result<(Episode, URL), PlayerModelController.Error> {
        
        var checkingIndex: Int
        
        switch type {
        case .current:
            checkingIndex = currentIndex
        case .next:
            checkingIndex = currentIndex - 1
        case .previous:
            checkingIndex = currentIndex + 1
        }
        
        return handle(with: checkingIndex, episodeType: type)
    }
    
    private func handle(with checkingIndex: Int, episodeType: EpisodeType) -> Result<(Episode, URL), PlayerModelController.Error> {
        if episodes.indices.contains(checkingIndex), let episode = episodes[checkingIndex].soundURL {
            let episode = episodes[checkingIndex]
            
            guard let soundURL = episode.soundURL else {
                return .failure(Error.noSoundURL)
            }
            
            switch episodeType {
            case .next:
                currentIndex -= 1
            case .previous:
                currentIndex += 1
            default:
                break
            }
            
            return .success((episode, soundURL))
        } else {
            return .failure(Error.indexOutOfRange)
        }
    }
}
