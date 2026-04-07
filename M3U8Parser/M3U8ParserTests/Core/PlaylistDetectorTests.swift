//
//  PlaylistDetectorTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser

struct PlaylistDetectorTests {

    @Test func detectsMasterPlaylistType() {
        let detector = PlaylistDetector()
        let type = detector.detect(from: "#EXTM3U\n#EXT-X-STREAM-INF:BANDWIDTH=800000\na.m3u8")
        #expect(type == .master)
    }

    @Test func detectsMediaPlaylistType() {
        let detector = PlaylistDetector()
        let type = detector.detect(from: "#EXTM3U\n#EXTINF:4.0,\nseg.ts")
        #expect(type == .media)
    }
}
