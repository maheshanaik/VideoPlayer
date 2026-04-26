//
//  ContentViewModel.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import Foundation
import Combine

// MARK: - ViewModel

@MainActor
class ContentViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var viewState: ContentViewState = .loading
    @Published var featuredContent: VideoContent?
    @Published var carouselItems: [VideoContent] = []
    @Published var sections: [ContentSection] = []
    
    // MARK: - Private Properties
    
    private let dataService: ContentDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(dataService: ContentDataServiceProtocol = ContentDataService()) {
        self.dataService = dataService
        loadContent()
    }
    
    // MARK: - Methods
    
    func loadContent() {
        Task {
            do {
                viewState = .loading
                
                // Simulate network delay
                try await Task.sleep(nanoseconds: 300_000_000)
                
                let featured = dataService.fetchFeaturedContent()
                let continueWatching = dataService.fetchContinueWatchingContent()
                let trending = dataService.fetchTrendingContent()
                let popular = dataService.fetchPopularContent()
                
                self.featuredContent = featured
                
                // Set carousel items from trending content (can be customized)
                self.carouselItems = [featured] + Array(trending.prefix(2))
                
                self.sections = [
                    ContentSection(
                        title: "Continue Watching",
                        content: continueWatching,
                        type: .continueWatching
                    ),
                    ContentSection(
                        title: "Trending Now",
                        content: trending,
                        type: .trending
                    ),
                    ContentSection(
                        title: "Popular on StreamFlow",
                        content: popular,
                        type: .popular
                    ),
                ]
                
                viewState = .success(sections)
            } catch {
                viewState = .error("Failed to load content")
            }
        }
    }
    
    func refreshContent() {
        loadContent()
    }
}
