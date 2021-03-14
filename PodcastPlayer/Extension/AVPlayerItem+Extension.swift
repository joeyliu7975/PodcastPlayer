//
//  AVPlayerItem+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/14/21.
//

import Foundation
import AVFoundation

extension CMTime {
    var inSeconds: Float64 {
        return CMTimeGetSeconds(self)
    }
}
