import AVFoundation
import Combine
import Foundation

/// PlayerViewModel follows MVVM pattern and manages player state and interactions
@MainActor
public final class PlayerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public private(set) var isLoading = false
    @Published public private(set) var lastError: Error?
    
    @Published public private(set) var isPlaying = false
    @Published public private(set) var currentTimeSeconds: Double = 0
    @Published public private(set) var durationSeconds: Double = 0
    
    @Published public private(set) var availableQualities: [HLSVideoQualityOption] = []
    @Published public private(set) var availableAudioTracks: [HLSAudioOption] = []
    
    @Published public var selectedQuality: HLSVideoQualityOption?
    @Published public var selectedAudioTrack: HLSAudioOption?
    
    // MARK: - Private Properties
    private let configuration: PlayerConfiguration
    private var subscriptions = Set<AnyCancellable>()
    private var timeObserver: Timer?
    
    public var avPlayer: AVPlayer? { (configuration.engine as? AVPlaybackEngine)?.player }
    
    // MARK: - Initialization
    public init(configuration: PlayerConfiguration? = nil) {
        // Create default configuration if not provided
        // This happens in a @MainActor context, so it's safe
        if let configuration {
            self.configuration = configuration
        } else {
            self.configuration = PlayerConfiguration()
        }
        setupBindings()
    }
    
    // MARK: - Public Methods
    public func load(manifestURL: URL) async {
        isLoading = true
        lastError = nil
        resetState()
        
        do {
            let playlistData = try await configuration.loadPlaylistUseCase.execute(url: manifestURL)
            
            availableQualities = playlistData.qualities
            availableAudioTracks = playlistData.audioTracks
            
            await configuration.engine.load(url: manifestURL)
            setupPlaybackObservers()
            
        } catch {
            lastError = error
        }
        
        isLoading = false
    }
    
    public func togglePlayPause() {
        if (configuration.engine as? AVPlaybackEngine)?.isPlaying ?? false {
            configuration.engine.pause()
            isPlaying = false
        } else {
            configuration.engine.play()
            isPlaying = true
        }
    }

    public func seek(to seconds: Double) {
        configuration.engine.seek(to: seconds)
    }

    // MARK: - Selection Updates
    public func updateQualitySelection(_ quality: HLSVideoQualityOption?) {
        selectedQuality = quality
        Task {
            await configuration.selectQualityUseCase.execute(quality, for: configuration.engine)
        }
    }

    public func updateAudioSelection(_ track: HLSAudioOption?) {
        selectedAudioTrack = track
        Task {
            await configuration.selectAudioTrackUseCase.execute(track, for: configuration.engine)
        }
    }

    // MARK: - Private Methods
    private func setupBindings() {
        timeObserver = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                let engine = self.configuration.engine as? AVPlaybackEngine
                self.currentTimeSeconds = engine?.currentTime ?? 0
                self.durationSeconds = engine?.duration ?? 0
                self.isPlaying = engine?.isPlaying ?? false
            }
        }
    }

    private func setupPlaybackObservers() {
        Task {
            let engine = self.configuration.engine as? AVPlaybackEngine
            self.isPlaying = engine?.isPlaying ?? false
            self.durationSeconds = engine?.duration ?? 0
            self.currentTimeSeconds = engine?.currentTime ?? 0
        }
    }

    private func resetState() {
        selectedQuality = nil
        selectedAudioTrack = nil
        availableQualities = []
        availableAudioTracks = []
        currentTimeSeconds = 0
        durationSeconds = 0
        isPlaying = false
    }

    deinit {
        timeObserver?.invalidate()
    }
}
