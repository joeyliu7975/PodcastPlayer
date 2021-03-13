//
//  PlayerViewModel.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/13/21.
//

import Foundation

public final class PlayerViewModel {
        
    public typealias TouchEvent = PlayerModel.EventType
    
    private var model: EpisodeManipulatible
    
    var playerState: PlayerViewModel.PlayerState = .playing {
        didSet {
            if playerState == .playing {
                playAudio?()
            } else {
                pauseAudio?()
            }
        }
    }
    
    var currentEpisode: Episode?
    //Closure:
    var update: ((Episode, URL) -> Void)?
    var playAudio: (() -> Void)?
    var pauseAudio: (() -> Void)?
    
    var soundtrackLoadingFailed: (() -> Void)?
    var episodeNotExistAlert: ((TouchEvent) -> Void)?

    public init(model: EpisodeManipulatible) {
        self.model = model
    }
}

extension PlayerViewModel {
    func loadEpisode(event: TouchEvent) {
        model.getEpisode(with: event, completion: { [weak self] (result) in
            switch result {
            case let .success((episode, url)):
                self?.update?(episode, url)
                self?.currentEpisode = episode
            case let .failure(error):
                self?.handleError(error: error, event: event)
                self?.playerState = .stopped
            }
        })
    }
    
    func updatePlayState(to state: PlayerState) {
        playerState = state
    }
    
    func updatePlayState(readyToPlay: Bool) {
        playerState = readyToPlay ? .playing : .stopped
    }
    
    func togglePlayState() {
        playerState.toggle()
    }
}

extension PlayerViewModel {
    func handleError(error: PlayerModel.Error, event: TouchEvent? = nil) {
        if error == .noSoundURL {
            soundtrackLoadingFailed?()
        } else if let event = event {
            episodeNotExistAlert?(event)
        }
    }
}

extension PlayerViewModel {
    enum PlayerState {
        case playing
        case stopped

        mutating func toggle() {
            switch self {
            case .playing: self = .stopped
            case .stopped: self = .playing
            }
        }
    }
}
