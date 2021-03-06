//
//  PlayerModelControllerTests.swift
//  PlayerModelControllerTests
//
//  Created by Joey Liu on 3/6/21.
//

import XCTest
@testable import PodcastPlayer

class PlayerModelControllerTests: XCTestCase {
    //MARK: Test function getSoundURL
    func test_getSoundURL_NoSoundURLError() {
        let episode = anyEpisode(soundURL: nil)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let expectedError = PlayerModelController.Error.noSoundURL
        
        XCTAssertThrowsError(try sut.getSoundURL(with: episode), "expect \(expectedError), but get return value instead.") { (error) in
            XCTAssertEqual((error as? PlayerModelController.Error), expectedError)
        }
    }
    
    func test_getSoundURL_hasSoundURL() {
        let expectedURL = anySoundURL()
        let episode = anyEpisode(soundURL: expectedURL)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        guard let result = try? sut.getSoundURL(with: episode) else {
            XCTFail("Error")
            return
        }
        
        switch result {
        case let .success((_, receivedURL)):
            XCTAssertNotNil(receivedURL)
            XCTAssertEqual(expectedURL, receivedURL)
        default:
            XCTFail("Expect\(expectedURL), but it throw error instead")
        }
    }
   
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
