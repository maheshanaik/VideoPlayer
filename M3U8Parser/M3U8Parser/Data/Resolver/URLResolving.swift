//
//  URLResolving.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

protocol URLResolving {
    func resolve(_ path: String?, base: URL) -> URL
}
