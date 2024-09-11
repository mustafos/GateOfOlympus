//
//  GateOfOlympusApp.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

@main
struct GateOfOlympusApp: App {
    @StateObject private var thunderManager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(thunderManager)
                .environmentObject(musicPlayer)
//            ExampleView()
        }
    }
}
