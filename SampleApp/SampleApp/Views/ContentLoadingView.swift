//
//  ContentLoadingView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct ContentLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.blue)
            
            Text("Loading content...")
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

#Preview {
    ContentLoadingView()
}
