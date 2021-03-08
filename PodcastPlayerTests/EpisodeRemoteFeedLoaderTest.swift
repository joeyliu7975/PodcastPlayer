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
        let (_, client, _) = makeSUT()
        // 沒有 call func load
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // #2. Test case: (call load 檢查client 有無執行 get)
    func test_load_requestDataFromURL() {
        let (sut, client, url) = makeSUT()
        
        sut.load { (_) in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // #3. Test case: 連續發兩次 Request
    func test_loadTwice_requestDataFromURL() {
        let (sut, client, url) = makeSUT()
        
        sut.load { (_) in }
        sut.load { (_) in }
        
        XCTAssertEqual(client.requestedURLs.count, 2)
        XCTAssertEqual(client.requestedURLs[0], url)
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    // #4. 發送 Request, 吐回失敗 Local Error:
    func test_load_deliverErrorOnClientError(){
        let (sut, client, _) = makeSUT()
            
        let exp = expectation(description: "Wait until completion")
        
        let expectedError = RemoteEpisodeFeedLoader.Error.connectivityError
        
        sut.load { (result) in
            switch result {
            case let .failure(receivedError as RemoteEpisodeFeedLoader.Error):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expect\(RemoteEpisodeFeedLoader.Error.connectivityError), but get \(result) instead")
            }
            
            exp.fulfill()
        }
        
        client.completeWithFailure(with: expectedError)
        wait(for: [exp], timeout: 3.0)
    }
    
    // #5. 發送 Request, 收到 Data 和 Response 但 statusCode 在錯誤區間:
    func test_load_deliverErrorOnNon2xxStatusCode() {
        let (sut, client, _) = makeSUT()
        
        let data = anyData()
        
        let statusCodes = [400, 500 ,100 , 301, 199]
        
        statusCodes.enumerated().forEach { (index, code) in
            let exp = expectation(description: "Wait until completion")
            
            let expectedError = RemoteEpisodeFeedLoader.Error.invalidData
            
            sut.load { (result) in
                switch result {
                case let .failure(receivedError as RemoteEpisodeFeedLoader.Error):
                    XCTAssertEqual(receivedError, expectedError)
                default:
                    XCTFail("Expect\(RemoteEpisodeFeedLoader.Error.connectivityError), but get \(result) instead")
                }
                exp.fulfill()
            }
            
            client.completeWithStatusCode(data: data, statusCode: code, at: index)
            wait(for: [exp], timeout: 3.0)
        }
    }
    
    //Helper:
    
    // 簡易做出 SystemUnderTest 和 Client:
    private func makeSUT() -> (RemoteEpisodeFeedLoader, HTTPClientSpy, URL){
        let url = anyURL()
        let client = HTTPClientSpy()
        let sut = RemoteEpisodeFeedLoader(client: client, url: url)
        
        return (sut, client, url)
    }
    
    // 簡易做出 url:
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    // 建議做出 XML data:
    private func anyData() -> Data {
        let string = """
                <channel>
                <title>股癌</title>
                    </channel>
                """
        return Data.init(bytes: string.utf8)
    }
    
    
    // HTTPClient 的 Test Double
    private class HTTPClientSpy: HTTPClient {
        
        var requestedURLs:[URL] {
            return receivedResults.map { $0.url }
        }
        
        var receivedResults = [(url:URL,completion: (HTTPClient.Result) -> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            receivedResults.append((url: url, completion: completion))
        }
        
        func completeWithFailure(with error: Error, at index: Int = 0) {
            receivedResults[index].completion(.failure(error))
        }
        
        func completeWithStatusCode(data: Data, statusCode: Int, at index: Int = 0) {
            let url = requestedURLs[index]
            
            let data = data
            
            let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            
            receivedResults[index].completion(.success((data,response)))
        }
            
    }
}
