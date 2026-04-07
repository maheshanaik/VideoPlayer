import AVFoundation
import Foundation

/// Core playback engine managing AVPlayer lifecycle and playback state
@MainActor
public protocol PlaybackEngine: AnyObject {
    var player: AVPlayer? { get }
    var isPlaying: Bool { get }
    var currentTime: Double { get }
    var duration: Double { get }
    
    func load(url: URL) async
    func play()
    func pause()
    func seek(to seconds: Double)
    func selectAudioTrack(_ option: AVMediaSelectionOption?)
    func setPreferredBitRate(_ bitRate: Double)
}

@MainActor
public final class AVPlaybackEngine: PlaybackEngine {
    public private(set) var player: AVPlayer?
    public private(set) var isPlaying = false
    public private(set) var currentTime: Double = 0
    public private(set) var duration: Double = 0
    
    private var timeObserver: Any?
    private var statusObservation: NSKeyValueObservation?
    private var itemObservation: NSKeyValueObservation?
    
    public init() {}
    
    public func load(url: URL) async {
        cleanup()
        
        let newPlayer = AVPlayer(url: url)
        self.player = newPlayer
        
        setupObservers(for: newPlayer)
    }
    
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func seek(to seconds: Double) {
        guard let player = player else { return }
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player.seek(to: time, toleranceBefore: .positiveInfinity, toleranceAfter: .positiveInfinity)
    }
    
    public func selectAudioTrack(_ option: AVMediaSelectionOption?) {
        guard let item = player?.currentItem else { return }
        guard let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible) else { return }
        item.select(option, in: group)
    }
    
    public func setPreferredBitRate(_ bitRate: Double) {
        guard let item = player?.currentItem else { return }
        item.preferredPeakBitRate = bitRate
    }
    
    private func setupObservers(for player: AVPlayer) {
        statusObservation = player.observe(\.timeControlStatus, options: [.initial, .new]) { [weak self] _, _ in
            guard let self else { return }
            self.isPlaying = player.timeControlStatus == .playing
        }
        
        if let item = player.currentItem {
            itemObservation = item.observe(\.status, options: [.initial, .new]) { [weak self] item, _ in
                guard let self else { return }
                if item.status == .readyToPlay {
                    self.duration = item.duration.seconds.isFinite ? item.duration.seconds : 0
                }
            }
        }
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            self.currentTime = time.seconds.isFinite ? time.seconds : 0
        }
    }
    
    private func cleanup() {
        if let timeObserver, let player {
            player.removeTimeObserver(timeObserver)
        }
        timeObserver = nil
        statusObservation = nil
        itemObservation = nil
        player?.pause()
        player = nil
    }
    
    @MainActor
deinit {
        cleanup()
    }
}
