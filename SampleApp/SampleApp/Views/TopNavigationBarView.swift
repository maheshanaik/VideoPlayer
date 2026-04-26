//
//  TopNavigationBarView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct TopNavigationBarView: View {
    @State private var showProfile = false
    
    var body: some View {
        HStack(spacing: 12) {
            SearchButtonView()
            
            Spacer()
            
            AppBrandView()
            
            Spacer()
            
            NavigationLink(destination: ProfileView()) {
                ProfileButtonView()
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Subcomponents

private struct SearchButtonView: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundColor(.white)
        }
    }
}

private struct AppBrandView: View {
    var body: some View {
        Text("StreamFlow")
            .font(.headline)
            .foregroundColor(.white)
    }
}

private struct ProfileButtonView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .font(.title3)
            .foregroundColor(.blue)
    }
}

#Preview {
    TopNavigationBarView()
        .padding()
        .background(Color.black)
}
