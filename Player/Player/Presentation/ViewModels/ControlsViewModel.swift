import Combine
import Foundation

///// ControlsViewModel manages the UI state and actions for player controls
//@MainActor
//public final class ControlsViewModel: ObservableObject {
//    // MARK: - Published Properties
//    @Published public var selectedQuality: HLSVideoQualityOption? {
//        didSet { onQualityChanged?(selectedQuality) }
//    }
//    @Published public var selectedAudioTrack: HLSAudioOption? {
//        didSet { onAudioChanged?(selectedAudioTrack) }
//    }
//    
//    @Published public var isPlaying: Bool {
//        didSet { onPlayPauseChanged?(isPlaying) }
//    }
//    
//    @Published public var currentTime: Double = 0
//    @Published public var duration: Double = 0
//    
//    // MARK: - Closures
//    public var onQualityChanged: ((HLSVideoQualityOption?) -> Void)?
//    public var onAudioChanged: ((HLSAudioOption?) -> Void)?
//    public var onPlayPauseChanged: ((Bool) -> Void)?
//    public var onSeekChanged: ((Double) -> Void)?
//    
//    // MARK: - Initialization
//    public init() {}
//    
//    // MARK: - Public Methods
//    public func seek(to time: Double) {
//        onSeekChanged?(time)
//    }
//    
//    public func updatePlayingState(_ isPlaying: Bool) {
//        self.isPlaying = isPlaying
//    }
//    
//    public func updateTime(current: Double, duration: Double) {
//        self.currentTime = current
//        self.duration = duration
//    }
//}
