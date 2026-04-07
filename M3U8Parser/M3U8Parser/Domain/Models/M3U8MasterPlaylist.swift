//
//  M3U8MasterPlaylist.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public struct M3U8MasterPlaylist {
    public let variants: [Variant]
    public let audioTracks: [AudioTrack]

    public init(variants: [Variant], audioTracks: [AudioTrack]) {
        self.variants = variants
        self.audioTracks = audioTracks
    }
}
