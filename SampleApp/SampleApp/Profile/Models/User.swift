//
//  User.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import Foundation
import SwiftUI

// MARK: - User Model

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    let avatar: String
    let joinDate: Date
    
    init(
        name: String,
        email: String,
        avatar: String,
        joinDate: Date = Date()
    ) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.avatar = avatar
        self.joinDate = joinDate
    }
}

// MARK: - User Settings

struct UserSettings: Codable {
    var notificationsEnabled: Bool
    var autoPlayEnabled: Bool
    var qualityPreference: VideoQuality
    var subtitlesEnabled: Bool
    var subtitleLanguage: String
    
    enum VideoQuality: String, CaseIterable, Codable {
        case auto = "Auto"
        case hd = "HD"
        case fullHD = "Full HD"
        case fourK = "4K"
    }
    
    static var `default`: UserSettings {
        UserSettings(
            notificationsEnabled: true,
            autoPlayEnabled: true,
            qualityPreference: .auto,
            subtitlesEnabled: false,
            subtitleLanguage: "English"
        )
    }
}

// MARK: - User Profile

struct UserProfile: Identifiable {
    let id: UUID
    let user: User
    let settings: UserSettings
    let watchlistCount: Int
    let totalWatchTime: Int // in minutes
    let favoriteCategories: [VideoCategory]
    
    var joinedMonthsAgo: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: user.joinDate, to: Date())
        return components.month ?? 0
    }
    
    var totalWatchTimeInHours: Int {
        totalWatchTime / 60
    }
}

// MARK: - Profile View State

enum ProfileViewState {
    case loading
    case success(UserProfile)
    case error(String)
}
