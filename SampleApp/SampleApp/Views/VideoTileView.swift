//
//  VideoTileView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct VideoTileView: View {
    let content: VideoContent
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(content.color.gradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(content.subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
            }
            .padding(12)
        }
        .frame(height: 160)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    VideoTileView(
        content: VideoContent(
            title: "Sample Title",
            subtitle: "Sample Subtitle",
            description: "Sample description",
            color: .blue,
            rating: 4.5,
            category: .scifi
        )
    )
    .padding()
    .background(Color.black)
}
