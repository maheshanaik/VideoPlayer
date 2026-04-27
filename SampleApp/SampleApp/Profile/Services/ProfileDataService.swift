//
//  ProfileDataService.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import Foundation
import SwiftUI

// MARK: - Service Protocol

protocol ProfileDataServiceProtocol {
    func fetchUserProfile() async throws -> UserProfile
    func updateUserSettings(_ settings: UserSettings) async throws
    func getWatchlistCount() -> Int
    func getTotalWatchTime() -> Int
}

// MARK: - Implementation

class ProfileDataService: ProfileDataServiceProtocol {
    
    private let mockUser = User(
        name: "Alex Johnson",
        email: "alex.johnson@streamflow.com",
        avatar: "person.circle.fill",
        joinDate: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date()
    )
    
    private var userSettings = UserSettings.default
    
    func fetchUserProfile() async throws -> UserProfile {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return UserProfile(
            id: UUID(),
            user: mockUser,
            settings: userSettings,
            watchlistCount: 24,
            totalWatchTime: 3240, // 54 hours
            favoriteCategories: [.scifi, .drama, .adventure]
        )
    }
    
    func updateUserSettings(_ settings: UserSettings) async throws {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000)
        
        self.userSettings = settings
    }
    
    func getWatchlistCount() -> Int {
        24
    }
    
    func getTotalWatchTime() -> Int {
        3240 // minutes
    }
}
