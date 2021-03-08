//
//  RemoteEpisodeFeedLoaderIntegrationTest.swift
//  RemoteEpisodeFeedLoaderIntegrationTest
//
//  Created by Joey Liu on 3/8/21.
//

import XCTest
import PodcastPlayer

class RemoteEpisodeFeedLoaderAPIIntegrationTest: XCTestCase {

    func test_load_callAPI() {
        let sut = makeSUT()
        
        let expectedProfileImage = expectedChannelProfileImage()
        
        let exp = expectation(description: "Wait until complete")
        
        sut.load { (result) in
            switch result {
            case let .success(feed):
                
                XCTAssertEqual(feed.profileImage, expectedProfileImage)
                self.expect(received: feed.episodes[0], expected: self.makeEpisodes(at: 0))
                self.expect(received: feed.episodes[1], expected: self.makeEpisodes(at: 1))
                self.expect(received: feed.episodes[2], expected: self.makeEpisodes(at: 2))
                self.expect(received: feed.episodes[3], expected: self.makeEpisodes(at: 3))
                self.expect(received: feed.episodes[4], expected: self.makeEpisodes(at: 4))
                self.expect(received: feed.episodes[5], expected: self.makeEpisodes(at: 5))
                self.expect(received: feed.episodes[6], expected: self.makeEpisodes(at: 6))
                self.expect(received: feed.episodes[7], expected: self.makeEpisodes(at: 7))
            case let .failure(error):
                XCTFail("Expected to get data, but get \(error) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    private func expect(received: Any, expected: Any) {
        guard let received = received as? Episode,
              let expected = expected as? Episode else {
            XCTFail("Error, got unexpected nil!")
            return
        }
        
        XCTAssertEqual(received.releaseDate, expected.releaseDate)
        XCTAssertEqual(received.title, expected.title)
        XCTAssertEqual(received.coverImage, expected.coverImage)
        XCTAssertEqual(received.soundURL, expected.soundURL)
    }
   
    // Helper:
    private func makeSUT() -> RemoteEpisodeFeedLoader {
        let feedTestURL = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss")!
        return RemoteEpisodeFeedLoader(client: URLSessionHTTPClient(), url: feedTestURL)
    }
    
    private func expectedChannelProfileImage() -> URL {
        return URL(string: "https://i1.sndcdn.com/avatars-000326154119-ogb1ma-original.jpg")!
    }
    
    private func makeEpisodes(at index: Int) -> Episode {
        let episode = Episode()
        episode?.coverImage = coverImage(at: index)
        episode?.soundURL = soundURL(at: index)
        episode?.title = title(at: index)
        episode?.releaseDate = date(at: index)
        return episode!
    }
    
    private func title(at index: Int) -> String? {
        return [
            "流動的資金盛宴",
            "數位藝術的畢卡索｜特別來賓「寶博朋友說」 葛如鈞",
            "貝佐斯領導亞馬遜的 27 年",
            "與它的挑戰者們｜特別來賓 Hustle Fund 程希瑾",
            "當擦鞋童都在聊 GameStop｜特別來賓股癌 謝孟恭",
            "汽車業最刺激的 10 年｜特別來賓陳鵬旭",
            "失去麥克風的川普，沒有責任的社群平台",
            "記錄每一顆原子的地圖"
        ][index]
    }
    
    private func date(at index: Int) -> String? {
        return [
            "Sun, 07 Mar 2021 22:00:12 +0000",
            "Sun, 28 Feb 2021 22:00:12 +0000",
            "Sun, 21 Feb 2021 22:00:15 +0000",
            "Sun, 07 Feb 2021 22:00:28 +0000",
            "Sun, 31 Jan 2021 22:00:17 +0000",
            "Sun, 24 Jan 2021 22:00:09 +0000",
            "Sun, 17 Jan 2021 22:00:09 +0000",
            "Sun, 10 Jan 2021 22:00:10 +0000"
        ][index]
    }
    
    
    private func coverImage(at index: Int) -> URL? {
        return URL(string: [
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg",
            "https://i1.sndcdn.com/artworks-Z7zJRFuDjv63KCHv-5W8whA-t3000x3000.jpg"
        ][index])
    }
    
    private func soundURL(at index: Int) -> URL? {
        return URL(string: [
            "https://feeds.soundcloud.com/stream/1000284829-daodutech-podcast-a-liquid-feast-of-capital.mp3",
            "https://feeds.soundcloud.com/stream/994918048-daodutech-podcast-how-to-become-digital-arts-picasso-guest-daab-jo-chun-ko.mp3",
            "https://feeds.soundcloud.com/stream/989907883-daodutech-the-27-year-of-bezos-at-amazon.mp3",
            "https://feeds.soundcloud.com/stream/980797063-daodutech-clubhouse-and-its-challengers-feature-hustle-fund-cjin-cheng.mp3",
            "https://feeds.soundcloud.com/stream/976314241-daodutech-when-shoeshine-boy-talks-about-gamestop-feature-gooaye-mengkeng-hsieh.mp3",
            "https://feeds.soundcloud.com/stream/971666359-daodutech-car-industry-the-most-exciting-10-year-guest-bob-chen.mp3",
            "https://feeds.soundcloud.com/stream/967233520-daodutech-trump-without-microphone.mp3",
            "https://feeds.soundcloud.com/stream/962915740-daodutech-mapping-every-atom.mp3"
        ][index])
    }

}
