//
//  ContentDataService.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import Foundation
import SwiftUI

// MARK: - Service Protocol

protocol ContentDataServiceProtocol {
    func fetchFeaturedContent() -> VideoContent
    func fetchContinueWatchingContent() -> [VideoContent]
    func fetchTrendingContent() -> [VideoContent]
    func fetchPopularContent() -> [VideoContent]
}

// MARK: - Implementation

class ContentDataService: ContentDataServiceProtocol {
    
    func fetchFeaturedContent() -> VideoContent {
        return VideoContent(
            title: "Future Horizon",
            subtitle: "Sci-Fi Thriller",
            description: "An epic journey through space and time",
            color: .blue,
            rating: 4.8,
            category: .scifi
        )
    }
    
    func fetchContinueWatchingContent() -> [VideoContent] {
        return [
            VideoContent(
                title: "Cosmic Journey",
                subtitle: "Science Fiction",
                description: "Explore the vastness of space",
                color: .cyan,
                rating: 4.5,
                category: .scifi
            ),
            VideoContent(
                title: "Desert Tales",
                subtitle: "Adventure",
                description: "Thrilling desert expeditions",
                color: .orange,
                rating: 4.3,
                category: .adventure
            ),
            VideoContent(
                title: "Neon Dreams",
                subtitle: "Thriller",
                description: "A night of mystery and suspense",
                color: .pink,
                rating: 4.6,
                category: .thriller
            ),
        ]
    }
    
    func fetchTrendingContent() -> [VideoContent] {
        return [
            VideoContent(
                title: "Earth Adventures",
                subtitle: "Documentary",
                description: "Nature's greatest wonders",
                color: .purple,
                rating: 4.7,
                category: .documentaryy
            ),
            VideoContent(
                title: "Future Horizon",
                subtitle: "Sci-Fi",
                description: "The future awaits",
                color: .blue,
                rating: 4.8,
                category: .scifi
            ),
            VideoContent(
                title: "City Nights",
                subtitle: "Drama",
                description: "Urban tales of love and loss",
                color: .indigo,
                rating: 4.4,
                category: .drama
            ),
            VideoContent(
                title: "Wild Escape",
                subtitle: "Adventure",
                description: "Escape to the wilderness",
                color: .teal,
                rating: 4.5,
                category: .adventure
            ),
            VideoContent(
                title: "Ocean Tales",
                subtitle: "Nature",
                description: "Mysteries of the deep",
                color: .green,
                rating: 4.6,
                category: .nature
            ),
            VideoContent(
                title: "Skyline Chase",
                subtitle: "Action",
                description: "High-speed pursuit across the city",
                color: .red,
                rating: 4.3,
                category: .action
            ),
        ]
    }
    
    func fetchPopularContent() -> [VideoContent] {
        return fetchTrendingContent().reversed()
    }
}
