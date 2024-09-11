//
//  Constant.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

enum Configurations {
    static var appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Unknown App Name"
    static let appleAppID = 6503482343
    static let adMobBanner = "ca-app-pub-4744463005672993/6244452174"
    static let adMobInterstitial = "ca-app-pub-4744463005672993/7925995661"
    static let feedback = UIImpactFeedbackGenerator(style: .soft)
}
