import Foundation
import M3U8Parser

/// Default implementation of PlaylistRepository using M3U8PlaylistParser
public final class DefaultPlaylistRepository: PlaylistRepository {
    private let parser: M3U8PlaylistParser
    
    public init(parser: M3U8PlaylistParser = M3U8PlaylistParser()) {
        self.parser = parser
    }
    
    public func fetch(url: URL) async throws -> M3U8Playlist {
        try await parser.parse(url: url)
    }
}

/// Default implementation of AudioTrackRepository
public final class DefaultAudioTrackRepository: AudioTrackRepository {
    public init() {}
    
    public func getAvailableTracks(from playlist: M3U8Playlist) -> [HLSAudioOption] {
        guard playlist.type == .master, let master = playlist.master else {
            return []
        }
        
        return Self.deduplicateAndSort(master.audioTracks)
    }
    
    private static func deduplicateAndSort(_ tracks: [AudioTrack]) -> [HLSAudioOption] {
        Dictionary(grouping: tracks.map { HLSAudioOption(track: $0) }, by: \.displayName)
            .compactMap { _, group in
                group.sorted { lhs, rhs in
                    if lhs.isDefault != rhs.isDefault { return lhs.isDefault }
                    return lhs.name < rhs.name
                }.first
            }
            .sorted { lhs, rhs in
                if lhs.isDefault != rhs.isDefault { return lhs.isDefault }
                return lhs.name < rhs.name
            }
    }
}

/// Default implementation of QualityRepository
public final class DefaultQualityRepository: QualityRepository {
    public init() {}
    
    public func getAvailableQualities(from playlist: M3U8Playlist) -> [HLSVideoQualityOption] {
        guard playlist.type == .master, let master = playlist.master else {
            return []
        }
        
        return Self.deduplicateAndSort(master.variants)
    }
    
    private static func deduplicateAndSort(_ variants: [Variant]) -> [HLSVideoQualityOption] {
        Dictionary(grouping: variants.map { HLSVideoQualityOption(variant: $0) }, by: \.displayName)
            .compactMap { _, group in
                group.max(by: { $0.bandwidth < $1.bandwidth })
            }
            .sorted { $0.bandwidth > $1.bandwidth }
    }
}
