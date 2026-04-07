//
//  M3U8ParserFacadeTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser
import Foundation

struct M3U8ParserFacadeTests {

    @Test func parserFacadeReturnsMasterType() async throws {
        let content = """
        #EXTM3U
        #EXT-X-STREAM-INF:BANDWIDTH=800000
        v1.m3u8
        """
        let parser = M3U8PlaylistParser(
            useCase: ParsePlaylistUseCaseImpl(
                network: MockNetworkClient(contentByURL: ["https://example.com/master.m3u8": content]),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: URLResolver()),
                mediaParser: MediaParser(resolver: URLResolver())
            )
        )

        let parsed = try await parser.parse(url: URL(string: "https://example.com/master.m3u8")!)
        #expect(parsed.type == .master)
        #expect(parsed.master?.variants.count == 1)
    }

    @Test func parserFacadeReturnsMediaType() async throws {
        let content = """
        #EXTM3U
        #EXTINF:6.0,
        seg.ts
        """
        let parser = M3U8PlaylistParser(
            useCase: ParsePlaylistUseCaseImpl(
                network: MockNetworkClient(contentByURL: ["https://example.com/media.m3u8": content]),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: URLResolver()),
                mediaParser: MediaParser(resolver: URLResolver())
            )
        )

        let parsed = try await parser.parse(url: URL(string: "https://example.com/media.m3u8")!)
        #expect(parsed.type == .media)
        #expect(parsed.media?.segments.count == 1)
    }

    @Test func throwsWhenHeaderIsMissing() async {
        let parser = M3U8PlaylistParser(
            useCase: ParsePlaylistUseCaseImpl(
                network: MockNetworkClient(contentByURL: ["https://example.com/master.m3u8": "#EXTINF:6.0,\nseg.ts"]),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: URLResolver()),
                mediaParser: MediaParser(resolver: URLResolver())
            )
        )

        await #expect(throws: M3U8ParserError.invalidManifestHeader) {
            try await parser.parse(url: URL(string: "https://example.com/master.m3u8")!)
        }
    }

    @Test func throwsWhenManifestIsEmpty() async {
        let parser = M3U8PlaylistParser(
            useCase: ParsePlaylistUseCaseImpl(
                network: MockNetworkClient(contentByURL: ["https://example.com/empty.m3u8": "   \n "]),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: URLResolver()),
                mediaParser: MediaParser(resolver: URLResolver())
            )
        )

        await #expect(throws: M3U8ParserError.emptyManifest) {
            try await parser.parse(url: URL(string: "https://example.com/empty.m3u8")!)
        }
    }

    @Test func propagatesNetworkError() async {
        let parser = M3U8PlaylistParser(
            useCase: ParsePlaylistUseCaseImpl(
                network: ThrowingNetworkClient(),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: URLResolver()),
                mediaParser: MediaParser(resolver: URLResolver())
            )
        )

        await #expect(throws: TestError.networkFailure) {
            try await parser.parse(url: URL(string: "https://example.com/fail.m3u8")!)
        }
    }
}
