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
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var thunderManager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    @StateObject private var interstitialAdManager = InterstitialAdsManager()
    
    init() {
        GADMobileAds.sharedInstance().start()
        NotificationManager.shared.requestAuthorization()
        //        NonConsumableManager.instance.fetchProducts()
    }
    
    var body: some Scene {
        WindowGroup {
//            LaunchScreenView()
//                .environmentObject(interstitialAdManager)
//                .environmentObject(thunderManager)
//                .environmentObject(musicPlayer)
//                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
//                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
//                }
            //            MainView()
                        StoreView()
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
        @unknown default:
            break
        }
    }
}
