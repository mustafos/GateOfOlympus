//
//  SettingsView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 07.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @State private var showNotification: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accentColor.ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView(image: "back", title: "Settings") {
                    dismiss()
                }.padding(.bottom, 34)
                
                VStack(alignment: .leading, spacing: 20) {
                    ParameterView(isOn: $musicPlayer.isMusicOn, image: musicPlayer.isMusicOn ? "music" : "musicOff", name: "Lock Sound")
                    
                    ParameterView(isOn: $musicPlayer.isSoundOn, image: musicPlayer.isSoundOn ? "sound" : "soundOff", name: "System Haptics")
                    
                    ParameterView(isOn: $showNotification, image: "bell", name: "Allow Notifications")
                    
                    ParameterView(isOn: $thunderManager.isUserLogin, image: "menu", name: "Delete Account")
                }
                .padding(20)
                Spacer()
            }
            .onAppear {
                if showNotification {
                    NotificationManager.shared.requestAuthorization()
                } else {
                    NotificationManager.shared.cancelNotification()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingsView()
}
