//
//  HLSPlayerView.swift
//  SampleApp
//

import AVKit
import SwiftUI
import Player

struct PlayerUIView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.entersFullScreenWhenPlaybackBegins = true
        controller.exitsFullScreenWhenPlaybackEnds = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Ensure it stays in full screen
        if !uiViewController.isBeingPresented && uiViewController.presentingViewController == nil {
            uiViewController.perform(NSSelectorFromString("enterFullScreenAnimated:completionHandler:"), with: true, with: nil)
        }
    }
}

struct HLSPlayerView: View {
    let manifestURL: URL

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = PlayerViewModel()

    var body: some View {
        ZStack(alignment: .topLeading) {
            playerLayer

            backButton

            if viewModel.avPlayer != nil {
                PlayerOverlayView(viewModel: viewModel)
            }
        }
        .navigationBarHidden(true)
        .task(id: manifestURL) {
            await viewModel.load(manifestURL: manifestURL)
            viewModel.togglePlayPause()
        }
    }

    @ViewBuilder
    private var playerLayer: some View {
        if let player = viewModel.avPlayer {
            PlayerUIView(player: player)
                .ignoresSafeArea()
        } else {
            Color.black.ignoresSafeArea()
        }
    }

    private var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.4))
                .clipShape(Circle())
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}

private struct PlayerOverlayView: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Spacer()
                CenterPlaybackControls(viewModel: viewModel)
                Spacer()
            }
            BottomRightSettings(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct CenterPlaybackControls: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        HStack(spacing: 28) {
            if viewModel.durationSeconds > 0 {
                SeekButton(systemName: "gobackward.10") {
                    let newTime = max(0, viewModel.currentTimeSeconds - 10)
                    viewModel.seek(to: newTime)
                }
            }

            Button(action: viewModel.togglePlayPause) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.35))
                        .frame(width: 80, height: 80)
                    Circle()
                        .stroke(Color.white.opacity(0.65), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)

            if viewModel.durationSeconds > 0 {
                SeekButton(systemName: "goforward.10") {
                    let newTime = min(viewModel.durationSeconds, viewModel.currentTimeSeconds + 10)
                    viewModel.seek(to: newTime)
                }
            }
        }
    }
}

private struct SeekButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(Circle().fill(Color.black.opacity(0.35)))
        }
    }
}

private struct BottomRightSettings: View {
    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        HStack(spacing: 8) {
            if !viewModel.availableQualities.isEmpty {
                SelectionMenu(label: "gearshape.fill", title: "Auto", items: viewModel.availableQualities, selected: viewModel.selectedQuality) { quality in
                    viewModel.updateQualitySelection(quality)
                }
            }

            if !viewModel.availableAudioTracks.isEmpty {
                SelectionMenu(label: "speaker.fill", title: "Auto", items: viewModel.availableAudioTracks, selected: viewModel.selectedAudioTrack) { track in
                    viewModel.updateAudioSelection(track)
                }
            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, 16)
        .frame(alignment: .bottomTrailing)
    }
}

private struct SelectionMenu<Item: Identifiable & Hashable>: View {
    let label: String
    let title: String
    let items: [Item]
    let selected: Item?
    let action: (Item?) -> Void

    var body: some View {
        Menu {
            Button(action: { action(nil) }) {
                HStack {
                    Text(title)
                    if selected == nil {
                        Image(systemName: "checkmark")
                    }
                }
            }

            ForEach(items, id: \.self) { item in
                Button(action: { action(item) }) {
                    HStack {
                        Text(displayName(for: item))
                        if selected == item {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.5))
                .clipShape(Capsule())
        }
    }

    private func displayName(for item: Item) -> String {
        if let quality = item as? HLSVideoQualityOption {
            return quality.displayName
        }
        if let track = item as? HLSAudioOption {
            return track.displayName
        }
        return "Unknown"
    }
}
