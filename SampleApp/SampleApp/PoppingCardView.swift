//
//  PoppingCardView.swift
//  SampleApp
//
//  Created by Assistant on 16/04/26.
//

import SwiftUI

struct PoppingCardView: View {
    let title: String
    let subtitle: String
    let color: Color
    
    @State private var isPressed = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(color.gradient)
                .aspectRatio(6/9, contentMode: .fit)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 8)
        .onTapGesture {
            withAnimation {
                isPressed.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    PoppingCardView(title: "Sample Title", subtitle: "Sample Subtitle", color: .purple)
        .frame(width: 150)
}