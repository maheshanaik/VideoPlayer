//
//  MediaParser.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

final class MediaParser: MediaParsing {

    private let resolver: URLResolving

    init(resolver: URLResolving) {
        self.resolver = resolver
    }

    func parse(_ content: String, baseURL: URL) throws -> M3U8MediaPlaylist {

        var segments: [Segment] = []
        var isLive = true
        var currentDuration: Double?
        var targetDuration: Double?
        var mediaSequence: Int?

        let lines = content.components(separatedBy: "\n")

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedLine.starts(with: "#EXTINF") {
                let durationStr = trimmedLine
                    .replacingOccurrences(of: "#EXTINF:", with: "")
                    .replacingOccurrences(of: ",", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                guard let duration = Double(durationStr) else {
                    throw M3U8ParserError.invalidNumericValue(tag: "#EXTINF", value: durationStr)
                }
                currentDuration = duration
            }
            else if trimmedLine.starts(with: "#EXT-X-TARGETDURATION:") {
                let value = trimmedLine
                    .replacingOccurrences(of: "#EXT-X-TARGETDURATION:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                guard let parsedTargetDuration = Double(value) else {
                    throw M3U8ParserError.invalidNumericValue(tag: "#EXT-X-TARGETDURATION", value: value)
                }
                targetDuration = parsedTargetDuration
            }
            else if trimmedLine.starts(with: "#EXT-X-MEDIA-SEQUENCE:") {
                let value = trimmedLine
                    .replacingOccurrences(of: "#EXT-X-MEDIA-SEQUENCE:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                guard let parsedMediaSequence = Int(value) else {
                    throw M3U8ParserError.invalidNumericValue(tag: "#EXT-X-MEDIA-SEQUENCE", value: value)
                }
                mediaSequence = parsedMediaSequence
            }
            else if !trimmedLine.starts(with: "#") && !trimmedLine.isEmpty {
                guard let duration = currentDuration else {
                    throw M3U8ParserError.mediaSegmentWithoutDuration
                }
                segments.append(
                    Segment(
                        duration: duration,
                        url: resolver.resolve(trimmedLine, base: baseURL)
                    )
                )
                self.currentDurationReset(&currentDuration)
            }
            else if trimmedLine == "#EXT-X-ENDLIST" {
                isLive = false
            }
        }

        guard !segments.isEmpty else {
            throw M3U8ParserError.noPlayableStreams
        }

        return M3U8MediaPlaylist(
            segments: segments,
            isLive: isLive,
            targetDuration: targetDuration,
            mediaSequence: mediaSequence
        )
    }

    private func currentDurationReset(_ duration: inout Double?) {
        duration = nil
    }
}
