//
//  PodcastPlayerTests.swift
//  PodcastPlayerTests
//
//  Created by Joey Liu on 2/25/21.
//

import XCTest
import PodcastPlayer

class PodcastPlayerTests: XCTestCase {

    func test_setupButtonTintColor() {
        let sut = PlayerViewController()
        
        sut.loadViewIfNeeded()
        
        let button = sut.playButton
        
        XCTAssertEqual(button?.tintColor, UIColor.kkBlue)
    }
}
