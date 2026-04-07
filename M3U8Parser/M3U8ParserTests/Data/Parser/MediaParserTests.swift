//
//  MediaParserTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser
import Foundation

struct MediaParserTests {

    @Test func parsesVodMediaPlaylistMetadata() throws {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://cdn.example.com/vod/main.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-TARGETDURATION:6
        #EXT-X-MEDIA-SEQUENCE:10
        #EXTINF:6.0,
        seg10.ts
        #EXTINF:6.0,
        seg11.ts
        #EXT-X-ENDLIST
        """

        let parsed = try parser.parse(playlist, baseURL: baseURL)

        #expect(parsed.isLive == false)
        #expect(parsed.targetDuration == 6)
        #expect(parsed.mediaSequence == 10)
        #expect(parsed.segments.count == 2)
        #expect(parsed.segments.first?.url.absoluteString == "https://cdn.example.com/vod/seg10.ts")
    }

    @Test func parsesLiveMediaPlaylistWithoutEndList() throws {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://live.example.com/ch1/index.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-TARGETDURATION:4
        #EXT-X-MEDIA-SEQUENCE:100
        #EXTINF:4.0,
        chunk100.ts
        #EXTINF:4.0,
        chunk101.ts
        """

        let parsed = try parser.parse(playlist, baseURL: baseURL)

        #expect(parsed.isLive == true)
        #expect(parsed.mediaSequence == 100)
        #expect(parsed.segments.count == 2)
    }

    @Test func throwsWhenMediaSegmentHasNoDuration() {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/live/index.m3u8")!
        let playlist = """
        #EXTM3U
        segment1.ts
        """

        #expect(throws: M3U8ParserError.mediaSegmentWithoutDuration) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenTargetDurationInvalid() {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/media.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-TARGETDURATION:abc
        #EXTINF:4.0,
        seg.ts
        """
        #expect(throws: M3U8ParserError.invalidNumericValue(tag: "#EXT-X-TARGETDURATION", value: "abc")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenMediaSequenceInvalid() {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/media.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-MEDIA-SEQUENCE:x1
        #EXTINF:4.0,
        seg.ts
        """
        #expect(throws: M3U8ParserError.invalidNumericValue(tag: "#EXT-X-MEDIA-SEQUENCE", value: "x1")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenExtinfDurationInvalid() {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/media.m3u8")!
        let playlist = """
        #EXTM3U
        #EXTINF:bad,
        seg.ts
        """
        #expect(throws: M3U8ParserError.invalidNumericValue(tag: "#EXTINF", value: "bad")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenMediaHasNoSegments() {
        let parser = MediaParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/media.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-TARGETDURATION:6
        """
        #expect(throws: M3U8ParserError.noPlayableStreams) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }
}
