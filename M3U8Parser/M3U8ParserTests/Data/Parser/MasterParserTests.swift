//
//  MasterParserTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser
import Foundation

struct MasterParserTests {

    @Test func parsesMasterPlaylistVariantsAndAudio() throws {
        let parser = MasterParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/hls/master.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-main",NAME="English",LANGUAGE="en",DEFAULT=YES,URI="audio/en.m3u8"
        #EXT-X-STREAM-INF:BANDWIDTH=1280000,RESOLUTION=640x360,CODECS="avc1.4d401f,mp4a.40.2",AUDIO="audio-main"
        low/playlist.m3u8
        """

        let parsed = try parser.parse(playlist, baseURL: baseURL)

        #expect(parsed.audioTracks.count == 1)
        #expect(parsed.variants.count == 1)
        #expect(parsed.variants.first?.bandwidth == 1_280_000)
        #expect(parsed.variants.first?.resolution?.width == 640)
        #expect(parsed.variants.first?.resolution?.height == 360)
        #expect(parsed.variants.first?.audioGroupId == "audio-main")
    }

    @Test func throwsWhenMasterVariantURIIsMissing() {
        let parser = MasterParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/master.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-STREAM-INF:BANDWIDTH=800000
        """

        #expect(throws: M3U8ParserError.missingURIAfterTag(tag: "#EXT-X-STREAM-INF")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenMasterBandwidthMissing() {
        let parser = MasterParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/master.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-STREAM-INF:RESOLUTION=640x360
        low/playlist.m3u8
        """
        #expect(throws: M3U8ParserError.missingRequiredAttribute(tag: "#EXT-X-STREAM-INF", attribute: "BANDWIDTH")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenMasterBandwidthInvalid() {
        let parser = MasterParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/master.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-STREAM-INF:BANDWIDTH=fast
        low/playlist.m3u8
        """
        #expect(throws: M3U8ParserError.invalidNumericValue(tag: "#EXT-X-STREAM-INF:BANDWIDTH", value: "fast")) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }

    @Test func throwsWhenMasterHasNoVariants() {
        let parser = MasterParser(resolver: URLResolver())
        let baseURL = URL(string: "https://example.com/master.m3u8")!
        let playlist = """
        #EXTM3U
        #EXT-X-VERSION:3
        """
        #expect(throws: M3U8ParserError.noPlayableStreams) {
            try parser.parse(playlist, baseURL: baseURL)
        }
    }
}
