//
//  GateOfOlympusApp.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI
import GoogleMobileAds

@main
struct GateOfOlympusApp: App {
    @StateObject private var thunderManager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    @StateObject private var interstitialAdManager = InterstitialAdsManager()
    
    init() {
        GADMobileAds.sharedInstance().start()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(interstitialAdManager)
                .environmentObject(thunderManager)
                .environmentObject(musicPlayer)
//            ExampleView()
        }
    }
}
