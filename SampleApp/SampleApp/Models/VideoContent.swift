//
//  VideoContent.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

// MARK: - Core Models

struct VideoContent: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let subtitle: String
    let description: String
    let color: Color
    let rating: Double
    let category: VideoCategory
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: VideoContent, rhs: VideoContent) -> Bool {
        lhs.id == rhs.id
    }
}

enum VideoCategory: String, CaseIterable {
    case documentaryy = "Documentary"
    case scifi = "Science Fiction"
    case drama = "Drama"
    case adventure = "Adventure"
    case nature = "Nature"
    case action = "Action"
    case thriller = "Thriller"
    
    var displayName: String {
        self.rawValue
    }
}

// MARK: - Content Collection Models

struct ContentSection: Identifiable {
    let id: UUID = UUID()
    let title: String
    let content: [VideoContent]
    let type: ContentSectionType
}

enum ContentSectionType {
    case featured
    case continueWatching
    case trending
    case popular
    case recommended
}

// MARK: - View State

enum ContentViewState {
    case loading
    case success([ContentSection])
    case error(String)
}
