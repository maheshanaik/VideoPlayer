//
//  URLResolverTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser
import Foundation

struct URLResolverTests {

    @Test func resolvesAbsoluteURL() {
        let resolver = URLResolver()
        let baseURL = URL(string: "https://example.com/path/master.m3u8")!
        let resolved = resolver.resolve("https://cdn.example.com/v1/seg.ts", base: baseURL)
        #expect(resolved.absoluteString == "https://cdn.example.com/v1/seg.ts")
    }

    @Test func resolvesRelativeURL() {
        let resolver = URLResolver()
        let baseURL = URL(string: "https://example.com/path/master.m3u8")!
        let resolved = resolver.resolve("video/seg.ts", base: baseURL)
        #expect(resolved.absoluteString == "https://example.com/path/video/seg.ts")
    }

    @Test func returnsBaseURLForInvalidPath() {
        let resolver = URLResolver()
        let baseURL = URL(string: "https://example.com/path/master.m3u8")!
        let resolved = resolver.resolve("  ", base: baseURL)
        #expect(resolved == baseURL)
    }
}
