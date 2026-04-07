//
//  ParsePlaylistUseCase.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public protocol ParsePlaylistUseCase {
    func execute(url: URL) async throws -> M3U8Playlist
}

final class ParsePlaylistUseCaseImpl: ParsePlaylistUseCase {

    private let network: NetworkFetching
    private let detector: PlaylistDetecting
    private let masterParser: MasterParsing
    private let mediaParser: MediaParsing

    init(
        network: NetworkFetching,
        detector: PlaylistDetecting,
        masterParser: MasterParsing,
        mediaParser: MediaParsing
    ) {
        self.network = network
        self.detector = detector
        self.masterParser = masterParser
        self.mediaParser = mediaParser
    }

    func execute(url: URL) async throws -> M3U8Playlist {

        let content = try await network.fetch(url: url)
        let sanitized = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty else { throw M3U8ParserError.emptyManifest }
        guard sanitized.contains("#EXTM3U") else { throw M3U8ParserError.invalidManifestHeader }

        let type = detector.detect(from: content)

        switch type {
        case .master:
            return M3U8Playlist(
                type: .master,
                master: try masterParser.parse(content, baseURL: url),
                media: nil
            )

        case .media:
            return M3U8Playlist(
                type: .media,
                master: nil,
                media: try mediaParser.parse(content, baseURL: url)
            )
        }
    }
}
