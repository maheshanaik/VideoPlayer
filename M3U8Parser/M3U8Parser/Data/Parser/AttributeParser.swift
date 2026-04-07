//
//  AttributeParser.swift
//  M3U8Parser
//
//  Created by Mahesh Naik on 01/04/26.
//

import Foundation

struct AttributeParser {
    func parse(_ line: String) -> [String: String] {
        guard let range = line.range(of: ":") else { return [:] }
        let attributesPart = String(line[range.upperBound...])

        var result: [String: String] = [:]
        var current = ""
        var inQuotes = false
        var tokens: [String] = []

        for char in attributesPart {
            if char == "\"" {
                inQuotes.toggle()
                current.append(char)
                continue
            }

            if char == "," && !inQuotes {
                let trimmed = current.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    tokens.append(trimmed)
                }
                current = ""
                continue
            }

            current.append(char)
        }

        let trailing = current.trimmingCharacters(in: .whitespaces)
        if !trailing.isEmpty {
            tokens.append(trailing)
        }

        tokens.forEach {
            let pair = $0.split(separator: "=", maxSplits: 1).map(String.init)
            guard pair.count == 2 else { return }
            result[pair[0]] = pair[1].replacingOccurrences(of: "\"", with: "")
        }

        return result
    }
}
