//
//  EpisodeRemoteFeedLoaderTest.swift
//  PodcastPlayerTests
//
//  Created by Joey Liu on 3/5/21.
//

import XCTest
@testable import PodcastPlayer

class EpisodeRemoteFeedLoaderTest: XCTestCase {

    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // #1. Test case:
    
    func test_load_doesNotLoadURL() {
        let url = URL(string:"https://any-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteEpisodeFeedLoader(client: client, url: url)
        
        // 沒有 call func load
        XCTAssertEqual(client.requestedURLs, [])
    }
    
//    func test_load_does
    
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
        }
    }
}
