//
//  HeroBannerView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct HeroBannerView: View {
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

// MARK: - Subcomponents

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
    HeroBannerView(
        content: VideoContent(
            title: "Future Horizon",
            subtitle: "Sci-Fi Thriller",
            description: "An epic journey through space and time",
            color: .blue,
            rating: 4.8,
            category: .scifi
        ),
        manifestURL: URL(string: "https://example.com/video.m3u8")!
    )
    .frame(height: 450)
    .background(Color.black)
}
