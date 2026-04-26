//
//  ProfileHeaderView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ProfileHeaderView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: profile.user.avatar)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            // User Info
            VStack(spacing: 8) {
                Text(profile.user.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(profile.user.email)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                // Member Info
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Member for \(profile.joinedMonthsAgo) months")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(.vertical, 24)
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
    
    ProfileHeaderView(profile: sampleProfile)
        .background(Color.black)
}
