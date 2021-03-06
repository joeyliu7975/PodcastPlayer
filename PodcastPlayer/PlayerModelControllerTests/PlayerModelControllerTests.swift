//
//  PlayerModelControllerTests.swift
//  PlayerModelControllerTests
//
//  Created by Joey Liu on 3/6/21.
//

import XCTest
@testable import PodcastPlayer

class PlayerModelControllerTests: XCTestCase {
    typealias TestError = PlayerModelController.Error
    //MARK: Test function getSoundURL
    func test_getSoundURL_NoSoundURLError() {
        let episode = anyEpisode(soundURL: nil)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let expectedError = TestError.noSoundURL
        
        let result = sut.getSoundURL(with: episode)
        
        switch result {
        case let .failure(receivedError):
            XCTAssertNotNil(receivedError)
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("expect \(expectedError), but get return value instead.")
        }
    }
    
    func test_getSoundURL_hasSoundURL() {
        let expectedURL = anySoundURL()
        let episode = anyEpisode(soundURL: expectedURL)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let result = sut.getSoundURL(with: episode)
        
        switch result {
        case let .success((_, receivedURL)):
            XCTAssertNotNil(receivedURL)
            XCTAssertEqual(expectedURL, receivedURL)
        default:
            XCTFail("Expect\(expectedURL), but it throw error instead")
        }
    }
    
    //MARK: test function findEpisode
    
    func test_findEpisode_IndexOutOfRange() {
        let episode = anyEpisode(soundURL: anySoundURL())
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let expectedError = TestError.indexOutOfRange
        
        let result = sut.findEpisode(at: 10)
        
        switch result {
        case let .failure(receivedError):
            XCTAssertNotNil(receivedError)
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Expect\(expectedError), but it throw error instead")
        }
    }
    
    func test_findEpisode_NoSoundURLError() {
        let episode = anyEpisode(soundURL: nil)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let expectedError = TestError.noSoundURL
        
        let result = sut.findEpisode(at: 0)
        
        switch result {
        case let .failure(receivedError):
            XCTAssertNotNil(receivedError)
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Expect\(expectedError), but it throw error instead")
        }
    }
    
    func test_findEpisode_hasSoundURL() {
        let expectedSoundURL = anySoundURL()
        let episode = anyEpisode(soundURL: expectedSoundURL)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let result = sut.findEpisode(at: 0)
        
        switch result {
        case let .success((_, receivedSoundURL)):
            XCTAssertEqual(expectedSoundURL, receivedSoundURL)
        default:
            XCTFail("Didn't get any value")
        }
    }
    
    // MARK: Test function start:
    
    // Helper:
    private func anyImageURL() -> URL {
        return URL(string: "https:any-url.com.jpg")!
    }
    
    private func anySoundURL() -> URL {
        return URL(string: "https://any-url.mp3")!
    }
    
    private func anyEpisode(soundURL: URL?) -> Episode {
        let coverImage = anyImageURL()
        
        let episode = Episode(coverImage: coverImage,
                title: "Hello",
                description: "Hello World",
                releaseDate: "Today",
                soundURL: soundURL)
        
       return episode
    }
}
