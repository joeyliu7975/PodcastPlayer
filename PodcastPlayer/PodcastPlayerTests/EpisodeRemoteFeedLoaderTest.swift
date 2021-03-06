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
    
    // #1. Test case: （沒有call function)
    
    func test_load_doesNotRequestDataFromURL() {
        let url = URL(string:"https://any-url.com")!
        let client = HTTPClientSpy()
        let _ = RemoteEpisodeFeedLoader(client: client, url: url)
        
        // 沒有 call func load
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // #2. Test case (call load 檢查client 有無執行 get)
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteEpisodeFeedLoader(client: client, url: url)
        
        sut.load { (_) in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //Helper:
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs = [URL]()
        var receivedResults = [(HTTPClient.Result) -> Void]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            requestedURLs.append(url)
            receivedResults.append(completion)
        }
        
        func complete(_ result:(HTTPClient.Result) -> Void) {
            
        }
    }
}
