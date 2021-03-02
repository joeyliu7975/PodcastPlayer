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
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
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
                let xmlParser = XMLParser(data: data)
                let delegate = HomeXMLParser()
                xmlParser.delegate = delegate
                
                if 200 ... 299 ~= response.statusCode && xmlParser.parse() {
                    completion(.success(delegate.channelFeed))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure(_):
                completion(.failure(Error.connectivityError))
            }
        }
    }
}
