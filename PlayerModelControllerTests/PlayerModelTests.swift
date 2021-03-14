//
//  PlayerModelTests.swift
//  PlayerModelTests
//
//  Created by Joey Liu on 3/6/21.
//

import XCTest
import PodcastPlayer

class PlayerModelTests: XCTestCase {
    typealias TestError = PlayerModel.Error
    //MARK: Test function getSoundURL
    func test_getSoundURL_NoSoundURLError() {
        let episode = anyEpisode(soundURL: nil)
        let sut = PlayerModel(episodes: [episode], currentIndex: 0)
        
        let expectedError = TestError.noSoundURL
        
        XCTAssertThrowsError(try sut.getSoundURL(with: episode), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
    }
    
    func test_getSoundURL_hasSoundURL() {
        let expectedURL = anySoundURL()
        let episode = anyEpisode(soundURL: expectedURL)
        let sut = PlayerModel(episodes: [episode], currentIndex: 0)
        
        do {
            let result = try sut.getSoundURL(with: episode)

            switch result {
            case let .success((_, receivedURL)):
                XCTAssertNotNil(receivedURL)
                XCTAssertEqual(expectedURL, receivedURL)
            default:
                XCTFail("Expect\(expectedURL), but it throw error instead")
            }
        } catch {
            XCTFail("Expect\(expectedURL), but it throw \(error) instead")
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
        
        let episode = Episode()
        
        episode?.coverImage = coverImage
        episode?.soundURL = soundURL

        return episode!
    }
}
