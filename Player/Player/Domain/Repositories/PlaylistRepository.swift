import Foundation
import M3U8Parser

/// Repository protocol for fetching and parsing playlists
public protocol PlaylistRepository {
    func fetch(url: URL) async throws -> M3U8Playlist
}

/// Repository protocol for audio track management
public protocol AudioTrackRepository {
    func getAvailableTracks(from playlist: M3U8Playlist) -> [HLSAudioOption]
}

/// Repository protocol for quality/variant management
public protocol QualityRepository {
    func getAvailableQualities(from playlist: M3U8Playlist) -> [HLSVideoQualityOption]
}
