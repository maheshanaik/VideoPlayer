//
//  M3U8Parser.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public enum M3U8ParserError: Error, Equatable {
    case emptyManifest
    case invalidManifestHeader
    case missingRequiredAttribute(tag: String, attribute: String)
    case missingURIAfterTag(tag: String)
    case invalidNumericValue(tag: String, value: String)
    case mediaSegmentWithoutDuration
    case noPlayableStreams
}

public final class M3U8PlaylistParser {

    private let useCase: ParsePlaylistUseCase

    public convenience init() {
        let resolver = URLResolver()

        self.init(
            useCase: ParsePlaylistUseCaseImpl(
                network: URLSessionNetworkClient(),
                detector: PlaylistDetector(),
                masterParser: MasterParser(resolver: resolver),
                mediaParser: MediaParser(resolver: resolver)
            )
        )
    }

    public init(useCase: ParsePlaylistUseCase) {
        self.useCase = useCase
    }

    public func parse(url: URL) async throws -> M3U8Playlist {
        try await useCase.execute(url: url)
    }
}
