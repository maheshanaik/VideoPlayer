//
//  ContentView.swift
//  SampleApp
//
//  Created by Mahesh Naik on 03/04/26.
//

import SwiftUI
import Player

struct ContentView: View {
    private let manifestURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8")!
    private let tiles: [VideoTile] = [
        .init(title: "Earth Adventures", subtitle: "Documentary", color: .purple),
        .init(title: "Future Horizon", subtitle: "Sci-Fi", color: .blue),
        .init(title: "City Nights", subtitle: "Drama", color: .indigo),
        .init(title: "Wild Escape", subtitle: "Adventure", color: .teal),
        .init(title: "Ocean Tales", subtitle: "Nature", color: .green),
        .init(title: "Skyline Chase", subtitle: "Action", color: .red)
    ]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .gray.opacity(0.9)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        header

                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(tiles) { tile in
                                NavigationLink(value: tile) {
                                    VideoTileView(tile: tile)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Featured")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: VideoTile.self) { _ in
                HLSPlayerView(manifestURL: manifestURL)
                    .navigationBarHidden(true)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Now Streaming")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Tap a title to watch the same featured stream.")
                .foregroundColor(.white.opacity(0.8))
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}

private struct VideoTile: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
}

private struct VideoTileView: View {
    let tile: VideoTile

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(tile.color.gradient)
                .frame(height: 190)

            VStack(alignment: .leading, spacing: 6) {
                Text(tile.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(tile.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
    }
}


#Preview {
    ContentView()
}
