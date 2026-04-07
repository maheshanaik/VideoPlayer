//
//  MasterParsing.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

protocol MasterParsing {
    func parse(_ content: String, baseURL: URL) throws -> M3U8MasterPlaylist
}
