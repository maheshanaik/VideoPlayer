import AVFoundation
import M3U8Parser

/// Configuration for the HLS Player with dependency injection
@MainActor
public final class PlayerConfiguration {
    public let engine: PlaybackEngine
    public let loadPlaylistUseCase: LoadPlaylistUseCase
    public let selectQualityUseCase: SelectQualityUseCase
    public let selectAudioTrackUseCase: SelectAudioTrackUseCase
    public let playlistRepository: PlaylistRepository
    public let audioRepository: AudioTrackRepository
    public let qualityRepository: QualityRepository
    
    public init(
        engine: PlaybackEngine? = nil,
        playlistRepository: PlaylistRepository? = nil,
        audioRepository: AudioTrackRepository? = nil,
        qualityRepository: QualityRepository? = nil
    ) {
        // Initialize dependencies with defaults or provided instances
        self.engine = engine ?? AVPlaybackEngine()
        self.playlistRepository = playlistRepository ?? DefaultPlaylistRepository()
        self.audioRepository = audioRepository ?? DefaultAudioTrackRepository()
        self.qualityRepository = qualityRepository ?? DefaultQualityRepository()
        
        // Initialize use cases with dependencies
        self.loadPlaylistUseCase = DefaultLoadPlaylistUseCase(
            playlistRepository: self.playlistRepository,
            audioRepository: self.audioRepository,
            qualityRepository: self.qualityRepository
        )
        self.selectQualityUseCase = DefaultSelectQualityUseCase()
        self.selectAudioTrackUseCase = DefaultSelectAudioTrackUseCase()
    }
}
