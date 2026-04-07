//
//  NetworkFetching.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

public protocol NetworkFetching {
    func fetch(url: URL) async throws -> String
}
