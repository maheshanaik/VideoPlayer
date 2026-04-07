//
//  M3U8PlaybackURLResolver.swift
//  Player
//

import Foundation
import M3U8Parser

enum M3U8PlaybackURLResolver {
    /// Resolves the URL to pass to `AVPlayer` after the manifest has been parsed.
    /// - Master playlists: highest-bandwidth variant stream URL.
    /// - Media playlists: the same manifest URL used for parsing.
    static func playbackURL(for playlist: M3U8Playlist, manifestURL: URL) throws -> URL {
        switch playlist.type {
        case .master:
            guard let variants = playlist.master?.variants, !variants.isEmpty else {
                throw M3U8ParserError.noPlayableStreams
            }
            return variants.max(by: { $0.bandwidth < $1.bandwidth })!.url
        case .media:
            return manifestURL
        }
    }
}
