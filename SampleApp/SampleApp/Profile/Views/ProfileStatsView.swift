//
//  ProfileStatsView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ProfileStatsView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Your Activity")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                StatCardView(
                    icon: "film.stack.fill",
                    label: "Watchlist",
                    value: String(profile.watchlistCount)
                )
                
                StatCardView(
                    icon: "clock.fill",
                    label: "Watch Time",
                    value: "\(profile.totalWatchTimeInHours)h"
                )
                
                StatCardView(
                    icon: "sparkles",
                    label: "Favorites",
                    value: String(profile.favoriteCategories.count)
                )
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Stat Card Component

private struct StatCardView: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    let sampleProfile = UserProfile(
        id: UUID(),
        user: User(
            name: "Alex Johnson",
            email: "alex.johnson@streamflow.com",
            avatar: "person.circle.fill"
        ),
        settings: .default,
        watchlistCount: 24,
        totalWatchTime: 3240,
        favoriteCategories: [.scifi, .drama]
    )
    
    ProfileStatsView(profile: sampleProfile)
        .padding()
        .background(Color.black)
}
