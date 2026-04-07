//
//  PlaylistDetecting.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

protocol PlaylistDetecting {
    func detect(from content: String) -> PlaylistType
}
