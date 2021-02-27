//
//  EpisodeFeedLoader.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import Foundation
import Alamofire
import AlamofireRSSParser

public protocol EpisodeFeedLoader {
    typealias Result = Swift.Result<RSSFeed, Error>
    
    func load(url: URL, completion: @escaping (Result) -> Void)
}

public final class AlamofireEpisodeFeedLoader: EpisodeFeedLoader {
    
    private let session: Session
    
    public init(session: Session = AF) {
        self.session = session
    }
    
    public enum Error: Swift.Error {
        case connectivityError
        case invalidData
    }
    
    public typealias Result = EpisodeFeedLoader.Result
    
    public func load(url: URL, completion: @escaping (Result) -> Void) {
        
        AF.request(url).responseRSS { (response) in
            if let feeds = response.value {
                completion(.success(feeds))
            } else if let _ = response.error {
                completion(.failure(Error.connectivityError))
            } else {
                completion(.failure(Error.invalidData))
            }
        }
    }
}
