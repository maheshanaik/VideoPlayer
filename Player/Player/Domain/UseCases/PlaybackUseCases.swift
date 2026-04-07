import AVFoundation
import Foundation
import M3U8Parser

/// Use case for loading and parsing a playlist
public protocol LoadPlaylistUseCase {
    func execute(url: URL) async throws -> PlayerPlaylistData
}

/// Use case for selecting quality
public protocol SelectQualityUseCase {
    func execute(_ quality: HLSVideoQualityOption?, for engine: PlaybackEngine) async
}

/// Use case for selecting audio track
public protocol SelectAudioTrackUseCase {
    func execute(_ track: HLSAudioOption?, for engine: PlaybackEngine) async
}

/// Data model for loaded playlist
public struct PlayerPlaylistData {
    public let playlist: M3U8Playlist
    public let audioTracks: [HLSAudioOption]
    public let qualities: [HLSVideoQualityOption]
    
    public init(
        playlist: M3U8Playlist,
        audioTracks: [HLSAudioOption],
        qualities: [HLSVideoQualityOption]
    ) {
        self.playlist = playlist
        self.audioTracks = audioTracks
        self.qualities = qualities
    }
}

// MARK: - Default Implementations

public final class DefaultLoadPlaylistUseCase: LoadPlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    private let audioRepository: AudioTrackRepository
    private let qualityRepository: QualityRepository
    
    public init(
        playlistRepository: PlaylistRepository,
        audioRepository: AudioTrackRepository,
        qualityRepository: QualityRepository
    ) {
        self.playlistRepository = playlistRepository
        self.audioRepository = audioRepository
        self.qualityRepository = qualityRepository
    }
    
    public func execute(url: URL) async throws -> PlayerPlaylistData {
        let playlist = try await playlistRepository.fetch(url: url)
        let audioTracks = audioRepository.getAvailableTracks(from: playlist)
        let qualities = qualityRepository.getAvailableQualities(from: playlist)
        
        return PlayerPlaylistData(
            playlist: playlist,
            audioTracks: audioTracks,
            qualities: qualities
        )
    }
}

public final class DefaultSelectQualityUseCase: SelectQualityUseCase {
    public init() {}
    
    @MainActor
    public func execute(_ quality: HLSVideoQualityOption?, for engine: PlaybackEngine) async {
        if let quality {
            engine.setPreferredBitRate(Double(quality.bandwidth))
        } else {
            engine.setPreferredBitRate(0)
        }
    }
}

public final class DefaultSelectAudioTrackUseCase: SelectAudioTrackUseCase {
    @MainActor
    public func execute(_ track: HLSAudioOption?, for engine: PlaybackEngine) async {
        guard let engine = engine as? AVPlaybackEngine else { return }
        
        guard let item = engine.player?.currentItem else { return }
        guard let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible) else { return }
        
        if let track {
            if let matchingOption = await findMatchingAudioOptionAsync(in: group, for: track) {
                item.select(matchingOption, in: group)
            }
        } else {
            item.select(nil, in: group)
        }
    }
    
    private func findMatchingAudioOption(
        in group: AVMediaSelectionGroup,
        for desired: HLSAudioOption
    ) -> AVMediaSelectionOption? {
        for option in group.options {
            if let desiredLanguage = desired.language, !desiredLanguage.isEmpty {
                if let extendedTag = option.extendedLanguageTag, extendedTag.hasPrefix(desiredLanguage) {
                    return option
                }
            }
            
            if !desired.name.isEmpty {
                // Try to match by language tag fallback or by name presence
                if !desired.name.isEmpty && option.extendedLanguageTag?.contains(desired.name) == true {
                    return option
                }
            }
        }
        
        return nil
    }
    
    private func findMatchingAudioOptionAsync(
        in group: AVMediaSelectionGroup,
        for desired: HLSAudioOption
    ) async -> AVMediaSelectionOption? {
        for option in group.options {
            if let desiredLanguage = desired.language, !desiredLanguage.isEmpty {
                if let extendedTag = option.extendedLanguageTag, extendedTag.hasPrefix(desiredLanguage) {
                    return option
                }
            }
            
            if !desired.name.isEmpty {
                // For iOS 16+, use the non-deprecated API but avoid stringValue
                if let extendedTag = option.extendedLanguageTag, extendedTag.hasPrefix(desired.name) {
                    return option
                }
            }
        }
        
        return nil
    }
}
