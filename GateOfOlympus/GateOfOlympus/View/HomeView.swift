//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isOnboarding") var isUserLogin: Bool?
    @Environment(\.dismiss) var dismiss
    @State private var musicOff: Bool = false
    @State private var soundOff: Bool = false
    private let feedback = UIImpactFeedbackGenerator(style: .soft)
    var body: some View {
        if isUserLogin == true {
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar()
                    Spacer()
                    NavigationLink {
                        MagicWheelView().navigationBarBackButtonHidden()
                    } label: {
                        GameCellContainer(name: "Magic Wheel", chevron: true)
                    }
                    
                    NavigationLink {
                        ThunderBallView().navigationBarBackButtonHidden()
                    } label: {
                        GameCellContainer(name: "God of Thunder", chevron: true)
                    }
                    Text("Hello").gradientButton()
                    Button("Show Onboarding") {
                        isUserLogin = false
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .background(Color.accentColor)
            }
            .navigationViewStyle(.stack)
        } else {
            OnboardingView()
        }
    }
    
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    musicOff.toggle()
                }
            } label: {
                Image(musicOff ? "musicOff" : "music")
            }
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    soundOff.toggle()
                }
            } label: {
                Image(soundOff ? "soundOff" : "sound")
            }
            Spacer()
            CoinsBalanceView(isCoins: true, score: "100")
            CoinsBalanceView(isCoins: false, score: "14")
        }
        .padding(.horizontal, 20)
        .padding(.top, 50)
        .padding(.bottom, 10)
        .frame(width: .infinity, height: 100)
        .background(Color.navigation)
    }
}

#Preview {
    HomeView()
}
