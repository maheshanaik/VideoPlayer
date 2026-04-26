//
//  ProfileErrorView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ProfileErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Error Loading Profile")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .font(.body)
                .padding(.horizontal)
            
            Button(action: onRetry) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .background(Color.black)
    }
}

#Preview {
    ProfileErrorView(message: "Failed to load your profile") {
        print("Retry tapped")
    }
}
