//
//  PlayerModelController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public final class PlayerModel: EpisodeManipulatible {
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
        case checkCurrentProject, checkPreviousProject, checkNextProject
    }
    
    public func getEpisode(with event: TouchEvent, completion: @escaping (Result) -> Void) {
        do {
            let result = try start(touchEvent: event)
            updateIndex(after: event)
            completion(result)
        } catch {
            completion(.failure(error as! PlayerModel.Error))
        }
    }
}

extension PlayerModel {
    public typealias Result = EpisodeManipulatible.Result
    public typealias TouchEvent = EventType
}

//MARK: Error Handling
extension PlayerModel {
    // #1 處理使用者不同的操作
    func start(touchEvent event: TouchEvent) throws -> Result {
        
        var targetIndex: Int
        
        switch event {
        case .checkCurrentProject:
            targetIndex = currentIndex
        case .checkNextProject:
            targetIndex = currentIndex - 1
        case .checkPreviousProject:
            targetIndex = currentIndex + 1
        }
        // #2 檢查是否 index out of range
        if episodes.indices.contains(targetIndex) {
            let episode = episodes[targetIndex]
            let result = try getSoundURL(with: episode)
            return result
        } else {
            throw Error.indexOutOfRange
        }
    }
   
    //#3 檢查指定 episode 中是否存在 soundURL
    func getSoundURL(with episode: Episode) throws -> Result {
        guard let url = episode.soundURL else {
            throw Error.noSoundURL
        }
        
        return .success((episode, url))
    }
}

extension PlayerModel {
    func updateIndex(after event: TouchEvent) {
        switch event {
        case .checkNextProject:
            currentIndex -= 1
        case .checkPreviousProject:
            currentIndex += 1
        default:
            break
        }
    }
}

public protocol EpisodeManipulatible {
    typealias Result = Swift.Result<(Episode, URL), PlayerModel.Error>
    typealias TouchEvent = PlayerModel.EventType
    
    func getEpisode(with event: TouchEvent, completion: @escaping (Result) -> Void)
    var episodes:[Episode] { get }
    var currentIndex: Int { get }
}
