//
//  AdsManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 12.09.2024.
//

import SwiftUI
import GoogleMobileAds

struct BannerView: View {
    
    var body: some View {
        AdMobBannerView()
            .frame(width: GADAdSizeBanner.size.width,
                   height: GADAdSizeBanner.size.height)
    }
}

struct AdMobBannerView: UIViewControllerRepresentable {
    
    let bannerView = GADBannerView(adSize: GADAdSizeBanner)
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        let viewController = UIViewController()
        bannerView.adUnitID = Configurations.adMobBanner
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        bannerView.load(GADRequest())
    }
}

// MARK: - INTERSTITIAL
class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
    
    // Properties
    @Published var interstitialAdLoaded: Bool = false
    var interstitialAd: GADInterstitialAd?
    
    override init() {
        super.init()
        loadInterstitialAd()
    }
    
    // Load InterstitialAd
    private func loadInterstitialAd() {
        GADInterstitialAd.load(withAdUnitID: Configurations.adMobInterstitial, request: GADRequest()) { [weak self] add, error in
            guard let self = self else {return}
            if let error = error{
                print("🔴: \(error.localizedDescription)")
                self.interstitialAdLoaded = false
                return
            }
            print("🟢: Loading succeeded")
            self.interstitialAdLoaded = true
            self.interstitialAd = add
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }
    
    // Display InterstitialAd
    func displayInterstitialAd(completion: @escaping () -> Void) {
        // Find the first active UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            // If the interstitial ad is loaded, present it
            if let ad = interstitialAd {
                ad.present(fromRootViewController: root)
                self.interstitialAdLoaded = false
                completion()
            } else {
                // If the ad isn't ready, load it again and proceed
                print("🔵: Ad wasn't ready")
                self.interstitialAdLoaded = false
                self.loadInterstitialAd()
                completion()
            }
        } else {
            print("🔵: No active window scene or root view controller found")
        }
    }
    
    // Failure notification
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("🟡: Failed to display interstitial ad")
        self.loadInterstitialAd()
    }
    
    // Indicate notification
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("🤩: Displayed an interstitial ad")
        self.interstitialAdLoaded = false
    }
    
    // Close notification
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("😔: Interstitial ad closed")
        loadInterstitialAd()
    }
}

