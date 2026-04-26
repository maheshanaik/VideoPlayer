//
//  ProfileView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .black.opacity(0.95)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Group {
                switch viewModel.viewState {
                case .loading:
                    ProfileLoadingView()
                case .success:
                    profileContentView
                case .error(let message):
                    ProfileErrorView(message: message) {
                        viewModel.loadProfile()
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var profileContentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // User Header
                if let profile = viewModel.userProfile {
                    ProfileHeaderView(profile: profile)
                }
                
                // Stats Section
                if let profile = viewModel.userProfile {
                    ProfileStatsView(profile: profile)
                        .padding(.horizontal)
                }
                
                // Settings Section
                SettingsSectionView(
                    settings: $viewModel.settings,
                    onToggleNotifications: { viewModel.toggleNotifications() },
                    onToggleAutoPlay: { viewModel.toggleAutoPlay() },
                    onToggleSubtitles: { viewModel.toggleSubtitles() },
                    onQualityChange: { viewModel.setQualityPreference($0) }
                )
                .padding(.horizontal)
                
                // Save Button
                Button(action: { viewModel.updateSettings() }) {
                    if viewModel.isSavingSettings {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Save Settings")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.horizontal)
                .disabled(viewModel.isSavingSettings)
                
                // Logout Button
                Button(action: {}) {
                    Text("Logout")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.vertical, 24)
        }
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
}
