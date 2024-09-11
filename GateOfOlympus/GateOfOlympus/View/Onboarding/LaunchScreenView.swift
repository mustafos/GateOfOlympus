//
//  LaunchScreenView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var interstitialAdManager: InterstitialAdsManager
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var isPreloadHomeScreen = false
    var body: some View {
        if isPreloadHomeScreen {
            HomeView()
                .environmentObject(interstitialAdManager)
                .environmentObject(thunderManager)
                .environmentObject(musicPlayer)
                .onAppear {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
        } else {
            ZStack {
                Color.accentColor.ignoresSafeArea()
                
                Image("LaunchIcon")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 70)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .overlay(alignment: .bottom) {
                        CustomProgressView(progress: opacity)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            interstitialAdManager.displayInterstitialAd {
                                isPreloadHomeScreen = true
                            }
                        }
                        withAnimation(.easeIn(duration: 1.2).repeatForever(autoreverses: true)) {
                            size = 1
                            opacity = 1
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func CustomProgressView(progress: CGFloat) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Image("progress")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.love, Color.heart]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: min(progress * geometry.size.width, geometry.size.width), height: 4)
                            .padding(2)
                    }
            }
        }.frame(width: 209, height: 10)
    }
}

#Preview {
    LaunchScreenView()
}
