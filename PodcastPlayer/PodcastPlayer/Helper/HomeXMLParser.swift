//
//  HomeXMLParser.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/1/21.
//

import Foundation

public final class HomeXMLParser: NSObject, XMLParserDelegate {
    // Simple state machine to capture fields and add completed Person to array
    var channelFeed: ChannelFeed = ChannelFeed()
    enum State {
        case none, title, pubDate, link, image, profileImage
    }

    var imageURLStr: String?
    var state: State = .none
    var newEpisode: Episode?

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
        case "item" :
            self.newEpisode = Episode()
            self.state = .none
        case "title":
            self.state = .title
        case "pubDate":
            self.state = .pubDate
        case "link":
            self.state = .link
        case "image" where newEpisode == nil:
            imageURLStr = "profileImage"
            self.state = .none
        case "itunes:image" where newEpisode != nil:
            if elementName == "itunes:image", let imageURL = attributeDict["href"] {
                self.newEpisode?.coverImage = URL(string: imageURL)
            }
        case "url":
            self.state = .profileImage
        default:
            self.state = .none
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if let imageURLStr = self.imageURLStr, elementName == "image" {
            self.channelFeed.profileImage = URL(string: imageURLStr)
            self.imageURLStr = nil
        }

        if let newEpisode = self.newEpisode, elementName == "item" {
            self.channelFeed.episodes.append(newEpisode)
            self.newEpisode = nil
        }
        self.state = .none

    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard newEpisode != nil || imageURLStr != nil  else { return }
        switch self.state {
        case .title:
            self.newEpisode?.title = string
        case .link:
            self.newEpisode?.coverImage = URL(string: string)
        case .pubDate:
            self.newEpisode?.releaseDate = string
        case .image:
            self.newEpisode?.coverImage = URL(string: string)
        case .profileImage:
            self.imageURLStr = string
        default:
            break
        }
    }

    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    }
}
