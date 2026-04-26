//
//  SettingsSectionView.swift
//  SampleApp
//
//  Created on 20/04/26.
//

import SwiftUI

struct SettingsSectionView: View {
    @Binding var settings: UserSettings
    var onToggleNotifications: () -> Void
    var onToggleAutoPlay: () -> Void
    var onToggleSubtitles: () -> Void
    var onQualityChange: (UserSettings.VideoQuality) -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                // Notifications
                SettingToggleView(
                    icon: "bell.fill",
                    label: "Notifications",
                    isOn: settings.notificationsEnabled,
                    action: onToggleNotifications
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Auto Play
                SettingToggleView(
                    icon: "play.fill",
                    label: "Auto Play",
                    isOn: settings.autoPlayEnabled,
                    action: onToggleAutoPlay
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Subtitles
                SettingToggleView(
                    icon: "captions.bubble.fill",
                    label: "Subtitles",
                    isOn: settings.subtitlesEnabled,
                    action: onToggleSubtitles
                )
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Video Quality
                SettingPickerView(
                    icon: "hd",
                    label: "Video Quality",
                    selectedValue: settings.qualityPreference,
                    options: UserSettings.VideoQuality.allCases,
                    onSelect: onQualityChange
                )
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

// MARK: - Setting Toggle Component

private struct SettingToggleView: View {
    let icon: String
    let label: String
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { isOn },
                set: { _ in action() }
            ))
            .tint(.blue)
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Setting Picker Component

private struct SettingPickerView: View {
    let icon: String
    let label: String
    let selectedValue: UserSettings.VideoQuality
    let options: [UserSettings.VideoQuality]
    let onSelect: (UserSettings.VideoQuality) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: { onSelect(option) }) {
                        HStack {
                            Text(option.rawValue)
                            if selectedValue == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedValue.rawValue)
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    @State var settings = UserSettings.default
    
    SettingsSectionView(
        settings: $settings,
        onToggleNotifications: { settings.notificationsEnabled.toggle() },
        onToggleAutoPlay: { settings.autoPlayEnabled.toggle() },
        onToggleSubtitles: { settings.subtitlesEnabled.toggle() },
        onQualityChange: { settings.qualityPreference = $0 }
    )
    .padding()
    .background(Color.black)
}
