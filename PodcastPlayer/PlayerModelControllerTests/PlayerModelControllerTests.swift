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
        
        XCTAssertThrowsError(try sut.getSoundURL(with: episode), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
    }
    
    func test_getSoundURL_hasSoundURL() {
        let expectedURL = anySoundURL()
        let episode = anyEpisode(soundURL: expectedURL)
        let sut = PlayerModelController(episodes: [episode], currentIndex: 0)
        
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
    
    //MARK: test function start
    
    func test_start_IndexOutOfRange() {
        let episode = anyEpisode(soundURL: anySoundURL())
        let sut = PlayerModelController(episodes: [episode], currentIndex: 2)
        
        let expectedError = TestError.indexOutOfRange
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkNextEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkPreviousEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkCurrentEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
    }
    
    func test_start_NoSoundURLError() {
        let expisodes = [Episode].init(repeating: anyEpisode(soundURL: nil), count: 3)
        let sut = PlayerModelController(episodes: expisodes, currentIndex: 1)
        
        let expectedError = TestError.noSoundURL
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkNextEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkPreviousEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
        
        XCTAssertThrowsError(try sut.start(touchEvent: .checkCurrentEP), "expect \(expectedError), but get return value instead.") { (receivedError) in
            XCTAssertEqual(receivedError as? TestError, expectedError)
        }
        
    }
    
    func test_start_hasSoundURL() {
        let expectedSoundURL = anySoundURL()
        let expisodes = [Episode].init(repeating: anyEpisode(soundURL: expectedSoundURL), count: 3)
        let sut = PlayerModelController(episodes: expisodes, currentIndex: 1)
        
        do {
            let result = try sut.start(touchEvent: .checkCurrentEP)
            
            switch result {
            case let .success((_, receivedSoundURL)):
                XCTAssertEqual(expectedSoundURL, receivedSoundURL)
            default:
                XCTFail("Didn't get any value")
            }
        } catch {
            XCTFail("Expect\(expectedSoundURL), but it throw \(error) instead")
        }
        
        do {
            let result = try sut.start(touchEvent: .checkNextEP)
            
            switch result {
            case let .success((_, receivedSoundURL)):
                XCTAssertEqual(expectedSoundURL, receivedSoundURL)
            default:
                XCTFail("Didn't get any value")
            }
        } catch {
            XCTFail("Expect\(expectedSoundURL), but it throw \(error) instead")
        }
        
        do {
            let result = try sut.start(touchEvent: .checkPreviousEP)
            
            switch result {
            case let .success((_, receivedSoundURL)):
                XCTAssertEqual(expectedSoundURL, receivedSoundURL)
            default:
                XCTFail("Didn't get any value")
            }
        } catch {
            XCTFail("Expect\(expectedSoundURL), but it throw \(error) instead")
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
