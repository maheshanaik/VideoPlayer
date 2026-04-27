//
//  ContentView.swift
//  SampleApp
//
//  Created by Mahesh Naik on 03/04/26.
//

import SwiftUI
import Player

struct ContentView: View {
    // MARK: - Constants
    
    private let manifestURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!
    
    // MARK: - State Management
    
    @StateObject private var viewModel = ContentViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [.black, .black.opacity(0.95)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Content State
                contentStateView
            }
            .navigationDestination(for: VideoContent.self) { _ in
                HLSPlayerView(manifestURL: manifestURL)
                    .navigationBarHidden(true)
            }
        }
    }
    
    // MARK: - Content State View
    
    @ViewBuilder
    private var contentStateView: some View {
        switch viewModel.viewState {
        case .loading:
            ContentLoadingView()
        case .success:
            mainContentView
        case .error(let message):
            ContentErrorView(message: message) {
                viewModel.refreshContent()
            }
        }
    }
    
    // MARK: - Main Content View
    
    private var mainContentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                if !viewModel.carouselItems.isEmpty {
                    HeroCarouselView(
                        items: viewModel.carouselItems,
                        manifestURL: manifestURL
                    )
                    .frame(height: 450)
                    .padding(.bottom, 32)
                }
                
                TopNavigationBarView()
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                
                ForEach(viewModel.sections) { section in
                    ContentSectionView(section: section, manifestURL: manifestURL)
                        .padding(.bottom, 32)
                }
            }
            .padding(.vertical, 0)
        }
    }
}

#Preview {
    ContentView()
}
