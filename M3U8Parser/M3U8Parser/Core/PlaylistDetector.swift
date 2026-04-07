//
//  PlaylistDetector.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

struct PlaylistDetector: PlaylistDetecting {
    func detect(from content: String) -> PlaylistType {
        content.contains("#EXT-X-STREAM-INF") ? .master : .media
    }
}
