//
//  AttributeParserTests.swift
//  M3U8ParserTests
//

import Testing
@testable import M3U8Parser

struct AttributeParserTests {

    @Test func parsesAttributesWithQuotedCommas() {
        let parser = AttributeParser()
        let attributes = parser.parse(#"#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="avc1.4d401f,mp4a.40.2",AUDIO="audio-main""#)
        #expect(attributes["BANDWIDTH"] == "1280000")
        #expect(attributes["CODECS"] == "avc1.4d401f,mp4a.40.2")
        #expect(attributes["AUDIO"] == "audio-main")
    }
}
