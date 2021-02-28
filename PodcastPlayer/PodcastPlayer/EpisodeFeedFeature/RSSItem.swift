//
//  RSSItem.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import Foundation

struct RSSData: Codable {
    let rss: RSS
}

// MARK: - RSS
struct RSS: Codable {
    let channel: Channel
    let xmlnsItunes: String
    let xmlnsAtom: String
    let version: String
}

// MARK: - Channel
struct Channel: Codable {
    let atomLink: String?
    let title: String
    let link: String
    let pubdate: String
    let lastBuildDate: String
    let ttl: String
    let language: String
    let copyright: String
    let webMaster: String
    let description: String
    let subtitle: String
    let owner: Owner
    let author: String
    let explicit: String
    let image: Image
    var item: [Item]
}

extension Channel {
    enum CodingKeys: String, CodingKey {
        case title, link, pubdate, lastBuildDate, ttl, language, copyright, webMaster, description, item
        case atomLink = "atom:link"
        case subtitle = "itunes:subtitle"
        case owner = "itunes:owner"
        case author = "itunes:author"
        case explicit = "itunes:explicit"
        case image = "itunes:image"
    }
}

struct Owner: Codable {
    let name: String
    let email: String
}

extension Owner {
    enum CodingKeys: String, CodingKey {
        case name = "itunes:name"
        case email = "itunes:email"
    }
}

struct Image: Codable {
    let url: String
    let title: String
    let link: String
}

struct Item: Codable {
    let guid: String
    let title: String
    let pubDate: String
    let link: String
    let duration: String
    let author: String
    let explicit: String
    let summary: String
    let subtitle: String
    let description: String
    let enclosure: String
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case guid, title, pubDate, link, description, enclosure
        case duration = "itunes:duration"
        case author = "itunes:author"
        case explicit = "itunes:explicit"
        case summary = "itunes:summary"
        case subtitle = "itunes:subtitle"
        case image = "itunes:image"
    }
}
