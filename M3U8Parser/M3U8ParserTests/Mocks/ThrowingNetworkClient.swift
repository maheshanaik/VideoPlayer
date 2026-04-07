//
//  ThrowingNetworkClient.swift
//  M3U8ParserTests
//

import Foundation
@testable import M3U8Parser

final class ThrowingNetworkClient: NetworkFetching {
    func fetch(url: URL) async throws -> String {
        throw TestError.networkFailure
    }
}
