//
//  EpisodeFeedLoader.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import Foundation

public final class RemoteEpisodeFeedLoader: EpisodeFeedLoader {
    
    private let client: HTTPClient
    private let url: URL
    private let mapper: FeedMapper
    
    public init(client: HTTPClient, url: URL, feedMapper: FeedMapper = HomeXMLParser()) {
        self.client = client
        self.url = url
        self.mapper = feedMapper
    }
    
    public enum Error: Swift.Error {
        case connectivityError
        case invalidData
    }
    
    public typealias Result = EpisodeFeedLoader.Result
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { (result) in
            switch result {
            case let .success((data, response)):
                // - MARK: 我想得到 .success(decoded data) 或 .failure(RemoteFeedLoader.Error)。這邊讓 private function map 處理
                
                completion(self.map(data: data, response: response))
            case .failure(_):
                completion(.failure(Error.connectivityError))
            }
        }
    }
}
// 去跑 FeedMapper 的 data,response 處理
extension RemoteEpisodeFeedLoader {
    private func map(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let feed = try mapper.map(data, response)
            return .success(feed)
        } catch {
            return .failure(error as! RemoteEpisodeFeedLoader.Error)
        }
    }
}
