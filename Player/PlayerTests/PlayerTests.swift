//
//  PlayerTests.swift
//  PlayerTests
//
//  Created by Mahesh Naik on 03/04/26.
//

import Foundation
import M3U8Parser
import Testing
@testable import Player

struct PlayerTests {

    @Test func playbackURL_masterPicksHighestBandwidth() throws {
        let manifest = URL(string: "https://example.com/master.m3u8")!
        let low = URL(string: "https://example.com/low.m3u8")!
        let high = URL(string: "https://example.com/high.m3u8")!
        let master = M3U8MasterPlaylist(
            variants: [
                Variant(bandwidth: 500_000, resolution: nil, codecs: nil, url: low, audioGroupId: nil),
                Variant(bandwidth: 2_000_000, resolution: nil, codecs: nil, url: high, audioGroupId: nil),
            ],
            audioTracks: []
        )
        let playlist = M3U8Playlist(type: .master, master: master, media: nil)
        let resolved = try M3U8PlaybackURLResolver.playbackURL(for: playlist, manifestURL: manifest)
        #expect(resolved == high)
    }

    @Test func playbackURL_mediaUsesManifestURL() throws {
        let manifest = URL(string: "https://example.com/media.m3u8")!
        let media = M3U8MediaPlaylist(segments: [], isLive: false, targetDuration: 6, mediaSequence: 0)
        let playlist = M3U8Playlist(type: .media, master: nil, media: media)
        let resolved = try M3U8PlaybackURLResolver.playbackURL(for: playlist, manifestURL: manifest)
        #expect(resolved == manifest)
    }
}
