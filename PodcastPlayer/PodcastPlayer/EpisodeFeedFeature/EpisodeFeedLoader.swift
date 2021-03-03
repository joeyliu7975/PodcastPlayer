//
//  EpisodeFeedLoader.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import Foundation

public protocol EpisodeFeedLoader {
    typealias Result = Swift.Result<ChannelFeed, Error>
    
    func load(completion: @escaping (Result) -> Void)
}

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
            let feed = try mapper.map(data: data, response: response)
            return .success(feed)
        } catch {
            return .failure(error as! RemoteEpisodeFeedLoader.Error)
        }
    }
}

// 我在這邊只會拿到 Data 和 response ,其他部分將會有 conform FeedMapper 的 class 去實作
public protocol FeedMapper {
    func map(data:Data, response: HTTPURLResponse) throws -> ChannelFeed
}
