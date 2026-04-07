//
//  MockNetworkClient.swift
//  M3U8ParserTests
//

import Foundation
@testable import M3U8Parser

final class MockNetworkClient: NetworkFetching {
    private let contentByURL: [String: String]

    init(contentByURL: [String: String]) {
        self.contentByURL = contentByURL
    }

    func fetch(url: URL) async throws -> String {
        contentByURL[url.absoluteString] ?? ""
    }
}
