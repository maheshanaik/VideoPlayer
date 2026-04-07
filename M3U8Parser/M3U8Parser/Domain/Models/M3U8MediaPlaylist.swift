//
//  M3U8MediaPlaylist.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public struct M3U8MediaPlaylist {
    public let segments: [Segment]
    public let isLive: Bool
    public let targetDuration: Double?
    public let mediaSequence: Int?

    public init(segments: [Segment], isLive: Bool, targetDuration: Double?, mediaSequence: Int?) {
        self.segments = segments
        self.isLive = isLive
        self.targetDuration = targetDuration
        self.mediaSequence = mediaSequence
    }
}
