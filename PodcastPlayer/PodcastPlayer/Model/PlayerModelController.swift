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
    
    public func getEpisode(type: TouchEvent, completion: @escaping (Result) -> Void) {
        completion(handle(type: type, currentIndex: currentIndex))
    }
}

//MARK: Error Handling
extension PlayerModelController {
    //MARK: #1 處理使用者不同的操作，用currentIndex檢驗
    func handle(type: TouchEvent, currentIndex: Int) -> Result {
        var checkingIndex: Int
        
        switch type {
        case .checkCurrentEP:
            checkingIndex = currentIndex
        case .checkNextEP:
            checkingIndex = currentIndex - 1
        case .checkPreviousEP:
            checkingIndex = currentIndex + 1
        }
        
        do {
            let result = try map(with: checkingIndex)
            
            self.currentIndex = checkingIndex
            
            return result
        } catch {
            return .failure(error as! Error)
        }
    }
    //MARK: #2 檢查currentIndex在Episodes中是否index out of range
    func map(with index: Int) throws -> Result {
        if episodes.indices.contains(index) {
            let episode = episodes[index]
            
            return try getSoundURL(with: episode)
        } else {
            throw Error.indexOutOfRange
        }
    }
    //MARK: #3 檢查指定episodes中的soundURL是否存在
    func getSoundURL(with episode: Episode) throws -> Result {
        guard let url = episode.soundURL else {
            throw Error.noSoundURL
        }
        
        return .success((episode, url))
    }
}

public protocol EpisodeManipulatible {
    typealias Result = Swift.Result<(Episode, URL), PlayerModelController.Error>
    typealias TouchEvent = PlayerModelController.EventType
    
    func getEpisode(type: TouchEvent, completion: @escaping (Result) -> Void)
    var episodes:[Episode] { get }
    var currentIndex: Int { get }
}
