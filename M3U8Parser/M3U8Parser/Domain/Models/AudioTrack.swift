//
//  AudioTrack.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public struct AudioTrack {
    public let id: String
    public let name: String
    public let language: String?
    public let isDefault: Bool
    public let url: URL
}
