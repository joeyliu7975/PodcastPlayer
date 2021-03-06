//
//  PlayerModelControllerTests.swift
//  PlayerModelControllerTests
//
//  Created by Joey Liu on 3/6/21.
//

import XCTest
@testable import PodcastPlayer

class PlayerModelControllerTests: XCTestCase {

    func test_getSoundURL_NoSoundURLError() {
        let episode = anyEpisode(soundURL: nil)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
        let expectedError = PlayerModelController.Error.noSoundURL
        
        XCTAssertThrowsError(try sut.getSoundURL(with: episode), "expect \(expectedError), but get return value instead.") { (error) in
            XCTAssertEqual((error as? PlayerModelController.Error), expectedError)
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
