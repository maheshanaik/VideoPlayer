//
//  Variant.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public struct Variant {
    public let bandwidth: Int
    public let resolution: CGSize?
    public let codecs: String?
    public let url: URL
    public let audioGroupId: String?

    public init(bandwidth: Int, resolution: CGSize?, codecs: String?, url: URL, audioGroupId: String?) {
        self.bandwidth = bandwidth
        self.resolution = resolution
        self.codecs = codecs
        self.url = url
        self.audioGroupId = audioGroupId
    }
}
