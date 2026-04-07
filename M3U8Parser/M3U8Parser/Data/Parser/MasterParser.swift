//
//  MasterParser.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

final class MasterParser: MasterParsing {

    private let attrParser = AttributeParser()
    private let resolver: URLResolving

    init(resolver: URLResolving) {
        self.resolver = resolver
    }

    func parse(_ content: String, baseURL: URL) throws -> M3U8MasterPlaylist {

        var variants: [Variant] = []
        var audioTracks: [AudioTrack] = []

        let lines = content.components(separatedBy: "\n")

        for (index, line) in lines.enumerated() {

            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedLine.starts(with: "#EXT-X-MEDIA") {
                let attr = attrParser.parse(line)

                if attr["TYPE"] == "AUDIO" {
                    audioTracks.append(
                        AudioTrack(
                            id: attr["GROUP-ID"] ?? "",
                            name: attr["NAME"] ?? "",
                            language: attr["LANGUAGE"],
                            isDefault: attr["DEFAULT"] == "YES",
                            url: resolver.resolve(attr["URI"], base: baseURL)
                        )
                    )
                }
            }

            if trimmedLine.starts(with: "#EXT-X-STREAM-INF") {
                let attr = attrParser.parse(line)
                guard let bandwidthValue = attr["BANDWIDTH"] else {
                    throw M3U8ParserError.missingRequiredAttribute(tag: "#EXT-X-STREAM-INF", attribute: "BANDWIDTH")
                }
                guard let bandwidth = Int(bandwidthValue) else {
                    throw M3U8ParserError.invalidNumericValue(tag: "#EXT-X-STREAM-INF:BANDWIDTH", value: bandwidthValue)
                }
                guard let nextLine = segmentPath(after: index, in: lines) else {
                    throw M3U8ParserError.missingURIAfterTag(tag: "#EXT-X-STREAM-INF")
                }

                variants.append(
                    Variant(
                        bandwidth: bandwidth,
                        resolution: parseResolution(attr["RESOLUTION"]),
                        codecs: attr["CODECS"],
                        url: resolver.resolve(nextLine, base: baseURL),
                        audioGroupId: attr["AUDIO"]
                    )
                )
            }
        }

        guard !variants.isEmpty else {
            throw M3U8ParserError.noPlayableStreams
        }

        return M3U8MasterPlaylist(variants: variants, audioTracks: audioTracks)
    }

    private func segmentPath(after index: Int, in lines: [String]) -> String? {
        guard index + 1 < lines.count else { return nil }

        for candidate in lines[(index + 1)...] {
            let trimmed = candidate.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty && !trimmed.starts(with: "#") {
                return trimmed
            }
        }

        return nil
    }

    private func parseResolution(_ value: String?) -> CGSize? {
        guard let value else { return nil }

        let parts = value.split(separator: "x").map(String.init)
        guard parts.count == 2,
              let width = Double(parts[0]),
              let height = Double(parts[1]) else {
            return nil
        }

        return CGSize(width: width, height: height)
    }
}
