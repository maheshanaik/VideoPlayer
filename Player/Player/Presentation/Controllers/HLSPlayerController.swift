//
//  HLSPlayerController.swift
//  Player
//

import AVFoundation
import Combine
import Foundation

/// HLSPlayerController manages HLS playback using the modular architecture.
/// It delegates to PlaybackEngine and UseCase layer for separation of concerns.
@MainActor
public final class HLSPlayerController: ObservableObject {

    public private(set) var manifestURL: URL?

    @Published public private(set) var isLoading = false
    @Published public var lastError: Error?

    // Playback state exposed for UI.
    @Published public private(set) var isPlaying = false
    @Published public private(set) var currentTimeSeconds: Double = 0
    @Published public private(set) var durationSeconds: Double = 0

    // Options (derived from the parsed master playlist).
    @Published public private(set) var availableQualities: [HLSVideoQualityOption] = []
    @Published public private(set) var availableAudioTracks: [HLSAudioOption] = []

    // Selection (nil means "Auto").
    @Published public var selectedQuality: HLSVideoQualityOption? {
        didSet {
            if oldValue != selectedQuality {
                Task {
                    await selectQuality(selectedQuality)
                }
            }
        }
    }

    @Published public var selectedAudioTrack: HLSAudioOption? {
        didSet {
            if oldValue != selectedAudioTrack {
                Task {
                    await selectAudioTrack(selectedAudioTrack)
                }
            }
        }
    }

    // Core AVPlayer is exposed for UI rendering.
    public var avPlayer: AVPlayer? { (configuration.engine as? AVPlaybackEngine)?.player }

    // MARK: - Architecture Components
    let configuration: PlayerConfiguration
    private var timeObserver: Timer?

    public init(configuration: PlayerConfiguration? = nil) {
        // Create default configuration if not provided
        // This happens in a @MainActor context, so it's safe
        if let configuration {
            self.configuration = configuration
        } else {
            self.configuration = PlayerConfiguration()
        }
    }

    public func load(manifestURL: URL) async {
        self.manifestURL = manifestURL

        isLoading = true
        lastError = nil
        defer { isLoading = false }

        // Reset selection/state for a new manifest.
        selectedQuality = nil
        selectedAudioTrack = nil
        availableQualities = []
        availableAudioTracks = []
        currentTimeSeconds = 0
        durationSeconds = 0
        isPlaying = false

        // Stop any existing playback observers.
        stopTimeObserver()

        do {
            // Use the load playlist use case to parse and prepare the playlist
            let playlistData = try await configuration.loadPlaylistUseCase.execute(url: manifestURL)

            // Update UI with available options from the parsed playlist
            availableQualities = playlistData.qualities
            availableAudioTracks = playlistData.audioTracks

            // Load the manifest into the playback engine
            await configuration.engine.load(url: manifestURL)

            // Start observing playback state
            startTimeObserver()
        } catch {
            lastError = error
        }
    }

    // MARK: - Playback Control
    public func play() {
        configuration.engine.play()
    }

    public func pause() {
        configuration.engine.pause()
    }

    public func togglePlayPause() {
        if (configuration.engine as? AVPlaybackEngine)?.isPlaying ?? false {
            configuration.engine.pause()
        } else {
            configuration.engine.play()
        }
    }

    public func seek(to seconds: Double) {
        configuration.engine.seek(to: seconds)
    }

    // MARK: - Selection
    func selectQuality(_ quality: HLSVideoQualityOption?) async {
        do {
            try await configuration.selectQualityUseCase.execute(quality, for: configuration.engine)
        } catch {
            self.lastError = error
        }
    }

    func selectAudioTrack(_ audio: HLSAudioOption?) async {
        do {
            try await configuration.selectAudioTrackUseCase.execute(audio, for: configuration.engine)
        } catch {
            self.lastError = error
        }
    }

    // MARK: - Private Methods
    private func startTimeObserver() {
        stopTimeObserver()

        timeObserver = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.currentTimeSeconds = (self.configuration.engine as? AVPlaybackEngine)?.currentTime ?? 0
                self.durationSeconds = (self.configuration.engine as? AVPlaybackEngine)?.duration ?? 0
                self.isPlaying = (self.configuration.engine as? AVPlaybackEngine)?.isPlaying ?? false
            }
        }
    }

    private func stopTimeObserver() {
        timeObserver?.invalidate()
        timeObserver = nil
    }

    deinit {
        timeObserver?.invalidate()
        timeObserver = nil
    }
}
