//
//  PlayerModelController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public final class PlayerModelController: EpisodeManipulatible {
    public typealias Result = EpisodeManipulatible.Result
    public typealias TouchEvent = EventType
    // MARK: - Episode:
    private(set) public var episodes:[Episode] = []
        
    private(set) public var currentIndex: Int
    
    public init(episodes:[Episode], currentIndex: Int) {
        self.episodes = episodes
        self.currentIndex = currentIndex
    }
    
    public enum Error: Swift.Error {
        case indexOutOfRange
        case noSoundURL
    }
    
    public enum EventType {
        case checkCurrentEP, checkPreviousEP, checkNextEP
    }
    
    public func getEpisode(with event: TouchEvent, completion: @escaping (Result) -> Void) {
        let result = start(touchEvent: event)
        
        switch result {
        case .success:
            updateIndex(after: event)
        default:
            break
        }
        
        completion(result)
    }
    
    private func updateIndex(after event: TouchEvent) {
        switch event {
        case .checkNextEP:
            currentIndex -= 1
        case .checkPreviousEP:
            currentIndex += 1
        default:
            break
        }
    }
}

//MARK: Error Handling
extension PlayerModelController {
    //MARK: #1 處理使用者不同的操作
    func start(touchEvent event: TouchEvent) -> Result {
        var targetIndex: Int
        
        switch event {
        case .checkCurrentEP:
            targetIndex = currentIndex
        case .checkNextEP:
            targetIndex = currentIndex - 1
        case .checkPreviousEP:
            targetIndex = currentIndex + 1
        }
        
       return findEpisode(at: targetIndex)
    }

    //MARK: #2 尋找 array 中是否有 target index
    func findEpisode(at index: Int) -> Result {
        if episodes.indices.contains(index) {
            let episode = episodes[index]
            
            return getSoundURL(with: episode)
        } else {
            return .failure(Error.indexOutOfRange)
        }
    }
   
    //MARK: #3 檢查指定 episode 中是否存在 soundURL
    func getSoundURL(with episode: Episode) -> Result {
        guard let url = episode.soundURL else {
            return .failure(Error.noSoundURL)
        }
        
        return .success((episode, url))
    }
}

public protocol EpisodeManipulatible {
    typealias Result = Swift.Result<(Episode, URL), PlayerModelController.Error>
    typealias TouchEvent = PlayerModelController.EventType
    
    func getEpisode(with event: TouchEvent, completion: @escaping (Result) -> Void)
    var episodes:[Episode] { get }
    var currentIndex: Int { get }
}
