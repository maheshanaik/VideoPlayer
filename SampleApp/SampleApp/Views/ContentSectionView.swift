//
//  ContentSectionView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ContentSectionView: View {
    let section: ContentSection
    let manifestURL: URL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitleView(title: section.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(section.content) { content in
                        NavigationLink(value: content) {
                            VideoTileView(content: content)
                                .frame(width: 140)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Subcomponents

private struct SectionTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal)
    }
}

#Preview {
    let sampleContent = [
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
    ]
    
    let section = ContentSection(
        title: "Trending Now",
        content: sampleContent,
        type: .trending
    )
    
    ContentSectionView(
        section: section,
        manifestURL: URL(string: "https://example.com/video.m3u8")!
    )
    .background(Color.black)
}
