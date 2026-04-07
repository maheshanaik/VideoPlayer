//
//  HLSPlayerModels.swift
//  Player
//

import Foundation
import M3U8Parser

public struct HLSVideoQualityOption: Identifiable, Equatable, Hashable {
    public let id: String
    public let bandwidth: Int
    public let resolution: CGSize?

    public var displayName: String {
        if let resolution, resolution.height > 0 {
            // Common HLS convention: 1920x1080 -> "1080p"
            return "\(Int(resolution.height))p"
        }
        return "\(bandwidth / 1000) kbps"
    }
}

public struct HLSAudioOption: Identifiable, Equatable, Hashable {
    public let id: String
    public let name: String
    public let language: String?
    public let isDefault: Bool

    public var displayName: String {
        if let language, !language.isEmpty, !name.isEmpty {
            return "\(name) (\(language))"
        }
        if !name.isEmpty { return name }
        return language ?? "Audio"
    }
}

extension HLSVideoQualityOption {
    init(variant: Variant) {
        let height = variant.resolution?.height ?? 0
        self.id = "\(variant.bandwidth)-\(Int(height))"
        self.bandwidth = variant.bandwidth
        self.resolution = variant.resolution
    }
}

extension HLSAudioOption {
    init(track: AudioTrack) {
        self.id = track.id
        self.name = track.name
        self.language = track.language
        self.isDefault = track.isDefault
    }
}
