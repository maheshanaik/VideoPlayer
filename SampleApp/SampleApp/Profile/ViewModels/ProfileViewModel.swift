//
//  ProfileViewModel.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import Foundation
import Combine

// MARK: - ViewModel

@MainActor
class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var viewState: ProfileViewState = .loading
    @Published var userProfile: UserProfile?
    @Published var settings: UserSettings = .default
    @Published var isSavingSettings = false
    
    // MARK: - Private Properties
    
    private let dataService: ProfileDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(dataService: ProfileDataServiceProtocol = ProfileDataService()) {
        self.dataService = dataService
        loadProfile()
    }
    
    // MARK: - Methods
    
    func loadProfile() {
        Task {
            do {
                viewState = .loading
                
                let profile = try await dataService.fetchUserProfile()
                self.userProfile = profile
                self.settings = profile.settings
                
                viewState = .success(profile)
            } catch {
                viewState = .error("Failed to load profile. Please try again.")
            }
        }
    }
    
    func updateSettings() {
        Task {
            do {
                isSavingSettings = true
                try await dataService.updateUserSettings(settings)
                
                if var profile = userProfile {
                    profile = UserProfile(
                        id: profile.id,
                        user: profile.user,
                        settings: settings,
                        watchlistCount: profile.watchlistCount,
                        totalWatchTime: profile.totalWatchTime,
                        favoriteCategories: profile.favoriteCategories
                    )
                    userProfile = profile
                }
                
                isSavingSettings = false
            } catch {
                viewState = .error("Failed to save settings. Please try again.")
                isSavingSettings = false
            }
        }
    }
    
    func toggleNotifications() {
        settings.notificationsEnabled.toggle()
    }
    
    func toggleAutoPlay() {
        settings.autoPlayEnabled.toggle()
    }
    
    func toggleSubtitles() {
        settings.subtitlesEnabled.toggle()
    }
    
    func setQualityPreference(_ quality: UserSettings.VideoQuality) {
        settings.qualityPreference = quality
    }
    
    func setSubtitleLanguage(_ language: String) {
        settings.subtitleLanguage = language
    }
}
