//
//  PlayerModelController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public final class PlayerModelController {
    typealias Result = Swift.Result<(Episode, URL), PlayerModelController.Error>
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
    
    func getEpisode(type: EpisodeType, completion: @escaping (Result) -> Void) {
        completion(handle(type: type, currentIndex: currentIndex))
    }
}
//MARK: Error Handling
private extension PlayerModelController {
    //MARK: #1 處理使用者不同的操作，用currentIndex檢驗
    private func handle(type: EpisodeType, currentIndex: Int) -> Result {
        var checkingIndex: Int
        
        switch type {
        case .current:
            checkingIndex = currentIndex
        case .next:
            checkingIndex = currentIndex - 1
        case .previous:
            checkingIndex = currentIndex + 1
        }
        
        do {
            let (episode, url) = try map(with: checkingIndex, episodeType: type)
            
            self.currentIndex = checkingIndex
            
            return .success((episode, url))
        } catch {
            return .failure(error as! Error)
        }
    }
    //MARK: #2 檢查currentIndex在Episodes中是否index out of range
    private func map(with index: Int, episodeType: EpisodeType) throws -> (Episode, URL) {
        if episodes.indices.contains(index), let soundURL = episodes[index].soundURL
        {
            let episode = episodes[index]
            return (episode, soundURL)
        } else {
            throw Error.indexOutOfRange
        }
    }
    //MARK: #3 檢查指定episodes中的soundURL是否存在
    private func getSoundURL(with episode: Episode) throws -> (Episode, URL) {
        guard let url = episode.soundURL else {
            throw Error.noSoundURL
        }
        
        return (episode, url)
    }
}
