//
//  HTTPClient.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/27/21.
//

import Foundation
import Alamofire
import AlamofireRSSParser

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
