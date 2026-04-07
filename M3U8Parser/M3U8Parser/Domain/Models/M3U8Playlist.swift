//
//  M3U8Playlist.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public struct M3U8Playlist {
    public let type: PlaylistType
    public let master: M3U8MasterPlaylist?
    public let media: M3U8MediaPlaylist?

    public init(type: PlaylistType, master: M3U8MasterPlaylist?, media: M3U8MediaPlaylist?) {
        self.type = type
        self.master = master
        self.media = media
    }
}
