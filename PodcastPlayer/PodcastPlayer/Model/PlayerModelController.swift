//
//  PlayerModelController.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/4/21.
//

import Foundation

public final class PlayerModelController: EpisodeManipulatible {
    typealias Result = EpisodeManipulatible.Result
    typealias TouchEvent = EventType
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
    
    public enum EventType {
        case checkCurrentEP, checkPreviousEP, checkNextEP
    }
    
    func getEpisode(type: TouchEvent, completion: @escaping (Result) -> Void) {
        completion(handle(type: type, currentIndex: currentIndex))
    }
}

//MARK: Error Handling
private extension PlayerModelController {
    //MARK: #1 處理使用者不同的操作，用currentIndex檢驗
    private func handle(type: TouchEvent, currentIndex: Int) -> Result {
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
            let (episode, url) = try map(with: checkingIndex)
            
            self.currentIndex = checkingIndex
            
            return .success((episode, url))
        } catch {
            return .failure(error as! Error)
        }
    }
    //MARK: #2 檢查currentIndex在Episodes中是否index out of range
    private func map(with index: Int) throws -> (Episode, URL) {
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

extension PlayerModelController {
    public struct Alert {
        let title: String
        let message: String
        let actionTitle: String
    }
    
    static func makeAlert(error errorType: Error, event: EventType) -> Alert {
        return (errorType == .noSoundURL) ?
        Alert(title: "提醒", message: "無法讀取音檔", actionTitle: "確認") :
        PlayerModelController.checkEvent(event)
    }
    
    private static func checkEvent(_ event: EventType) -> Alert {
        switch event {
        case .checkCurrentEP:
            return Alert(title: "提醒", message: "當前的 Podcast 出現異常", actionTitle: "確認")
        case .checkPreviousEP:
            return Alert(title: "提醒", message: "這首已經是最舊的 Podcast 了", actionTitle: "確認")
        case .checkNextEP:
            return Alert(title: "提醒", message: "這首已經是最新的 Podcast 了", actionTitle: "確認")
        }
    }
}

protocol EpisodeManipulatible {
    associatedtype TouchEvent
    typealias Result = Swift.Result<(Episode, URL), PlayerModelController.Error>
    
    func getEpisode(type: TouchEvent, completion: @escaping (Result) -> Void)
}

