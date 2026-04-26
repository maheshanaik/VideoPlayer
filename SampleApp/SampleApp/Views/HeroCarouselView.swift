//
//  HeroCarouselView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct HeroCarouselView: View {
    let items: [VideoContent]
    let manifestURL: URL
    
    @State private var currentIndex = 0
    @State private var autoScrollTimer: Timer?
    
    private let autoScrollInterval: TimeInterval = 5.0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<items.count, id: \.self) { index in
                        HeroCarouselItemView(
                            content: items[index],
                            manifestURL: manifestURL
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: currentIndex) { _ in
                    resetAutoScroll()
                }
            }
            
            // Pagination Dots - Outside carousel, below content
            PaginationDotsView(
                totalItems: items.count,
                currentIndex: currentIndex
            )
            .padding(.vertical, 16)
        }
        .onAppear {
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
    }
    
    // MARK: - Auto Scroll Methods
    
    private func startAutoScroll() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func resetAutoScroll() {
        stopAutoScroll()
        startAutoScroll()
    }
}

// MARK: - Hero Carousel Item Component

struct HeroCarouselItemView: View {
    let content: VideoContent
    let manifestURL: URL
    
    var body: some View {
        NavigationLink(value: content) {
            ZStack(alignment: .bottomLeading) {
                // Background
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [content.color.opacity(0.6), content.color.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Overlay gradient
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                
                // Content
                VStack(alignment: .leading, spacing: 16) {
                    Text(content.title)
                        .font(.system(size: 48, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    HStack(spacing: 12) {
                        Label(String(format: "%.1f", content.rating), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(content.subtitle)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.subheadline)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        PlayButtonView()
                        MyListButtonView()
                    }
                }
                .padding(24)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pagination Dots Component

struct PaginationDotsView: View {
    let totalItems: Int
    let currentIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalItems, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                    .frame(width: index == currentIndex ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Button Components

private struct PlayButtonView: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                Text("Play")
            }
            .font(.headline)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

private struct MyListButtonView: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                Text("My List")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

#Preview {
    let sampleItems = [
        VideoContent(
            title: "Future Horizon",
            subtitle: "Sci-Fi Thriller",
            description: "An epic journey through space and time",
            color: .blue,
            rating: 4.8,
            category: .scifi
        ),
        VideoContent(
            title: "Ocean Tales",
            subtitle: "Nature Documentary",
            description: "Mysteries of the deep",
            color: .green,
            rating: 4.6,
            category: .nature
        ),
        VideoContent(
            title: "City Nights",
            subtitle: "Drama",
            description: "Urban tales of love and loss",
            color: .indigo,
            rating: 4.4,
            category: .drama
        ),
    ]
    
    HeroCarouselView(
        items: sampleItems,
        manifestURL: URL(string: "https://example.com/video.m3u8")!
    )
    .frame(height: 450)
    .background(Color.black)
}
