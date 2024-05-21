//
//  LaunchScreenView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var isPreloadHomeScreen = false
    var body: some View {
        if isPreloadHomeScreen {
            HomeView()
        } else {
            ZStack {
                Color.accentColor.ignoresSafeArea()
                Image("LaunchIcon")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 70)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isPreloadHomeScreen = true
                        }
                        withAnimation(.easeIn(duration: 1.2).repeatForever(autoreverses: true)) {
                            size = 1
                            opacity = 1
                        }
                    }
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
