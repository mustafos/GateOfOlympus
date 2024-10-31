//
//  GateOfOlympusApp.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct GateOfOlympusApp: App {
    // MARK: - Properties
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var thunderManager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    @StateObject private var interstitialAdManager = InterstitialAdsManager()
    
    private let purchaseProvider = PurchaseManager()
    
    init() {
        GADMobileAds.sharedInstance().start()
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(interstitialAdManager)
                .environmentObject(thunderManager)
                .environmentObject(musicPlayer)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
                }
        }
        .onChange(of: scenePhase) { newScenePhase in
            processScenePhaseChange(to: newScenePhase)
        }
    }
    
    // MARK: - Lifecycle
    func processScenePhaseChange(to phase: ScenePhase) {
        switch phase {
        case .background:
            break
        case .inactive:
            break
        case .active:
            UIApplication.shared.applicationIconBadgeNumber = 0
            if thunderManager.isNotifyEnabled {
                NotificationManager.shared.scheduleDailyNotification()
                NotificationManager.shared.timeNotification()
            }
            interstitialAdManager.displayInterstitialAd {
                print("Some action after interstitial ad is displayed")
            }
        @unknown default:
            break
        }
    }
}
