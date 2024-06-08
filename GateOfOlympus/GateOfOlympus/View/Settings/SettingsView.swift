//
//  SettingsView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 07.06.2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    @State private var showNotification: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    HeaderView().padding(.bottom, 34)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ParameterView(isOn: $musicPlayer.isMusicOn, image: musicPlayer.isMusicOn ? "music" : "musicOff", name: "Lock Sound")
//                            .onTapGesture {
//                                withAnimation {
//                                    feedback.impactOccurred()
//                                    musicPlayer.isMusicOn.toggle()
//                                    if musicPlayer.isPlaying {
//                                        musicPlayer.stopBackgroundMusic()
//                                    } else {
//                                        musicPlayer.playBackgroundMusic(fileName: "olympus", fileType: "mp3")
//                                    }
//                                }
//                            }
                        ParameterView(isOn: $musicPlayer.isSoundOn, image: musicPlayer.isSoundOn ? "sound" : "soundOff", name: "System Haptics")
//                            .onTapGesture {
//                                withAnimation {
//                                    feedback.impactOccurred()
//                                    musicPlayer.isSoundOn.toggle()
//                                }
//                            }
                        ParameterView(isOn: $showNotification, image: "menu", name: "Allow Notifications")
//                            .onTapGesture {
//                                withAnimation {
//                                    feedback.impactOccurred()
//                                    NotificationManager.shared.cancelNotification()
//                                }
//                            }
                        ParameterView(isOn: $manager.isUserLogin, image: "menu", name: "Delete Account")
//                            .onTapGesture {
//                                withAnimation {
//                                    musicPlayer.playBackgroundMusic(fileName: "olympus", fileType: "mp3")
//                                    isUserLogin = false
//                                }
//                            }
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
        }.navigationViewStyle(.stack)
    }
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                    dismiss()
                }
            } label: {
                Image("back")
            }
            Text("Settings")
                .modifier(TitleModifier(size: 18, color: .white))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
            CoinsBalanceView(isCoins: true, score: "\(manager.coins)")
            CoinsBalanceView(isCoins: false, score: "\(manager.hearts)")
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.navigation)
    }
}

#Preview {
    SettingsView()
}
