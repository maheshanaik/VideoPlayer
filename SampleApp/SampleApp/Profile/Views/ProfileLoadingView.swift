//
//  ProfileLoadingView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ProfileLoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                // Skeleton Avatar
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .shimmer()
                
                // Skeleton Text
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 20)
                        .frame(maxWidth: 150)
                        .shimmer()
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 14)
                        .frame(maxWidth: 200)
                        .shimmer()
                }
            }
            .padding(.vertical, 24)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Shimmer Effect Extension

extension View {
    func shimmer() -> some View {
        self
            .redacted(reason: .placeholder)
            .animation(.linear.repeatForever(autoreverses: true), value: UUID())
    }
}

#Preview {
    ProfileLoadingView()
}
