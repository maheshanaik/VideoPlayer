//
//  URLResolver.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

struct URLResolver: URLResolving {
    func resolve(_ path: String?, base: URL) -> URL {
        guard let rawPath = path?.trimmingCharacters(in: .whitespacesAndNewlines), !rawPath.isEmpty else {
            return base
        }

        if let absoluteURL = URL(string: rawPath), absoluteURL.scheme != nil {
            return absoluteURL
        }

        if let resolved = URL(string: rawPath, relativeTo: base)?.absoluteURL {
            return resolved
        }

        return base
    }
}
