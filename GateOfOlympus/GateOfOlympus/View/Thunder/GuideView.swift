//
//  GuideView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 22.05.2024.
//

import SwiftUI

struct GuideView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ThunderViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    HeaderView().padding(.bottom, 34)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Collect combinations of 3 or more elements in a row and get extra points.")
                        Image("mover")
                        Text("You have a limited number of moves and time. If there are several combinations, then the number of points is multiplied and you will quickly gain the number of points needed for your victory.")
                        Image("stars")
                        Text("Use your dexterity and attention skills to quickly complete levels and receive additional rewards.")
                        HStack(spacing: 6) {
                            Image("love")
                                .resizable()
                                .scaledToFit()
                            Text("5")
                        }
                        .frame(height: 24)
                        .modifier(TitleModifier(size: 14, color: .white))
                        Text("The game has a daily quiz where you can try your luck and win additional bonuses that will help you. The quiz is held only once a day")
                    }
                    .modifier(BodyModifier(size: 14, color: .white))
                    .padding(20)
                    Spacer()
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
                    dismiss()
                }
            } label: {
                Image("back")
            }
            Spacer()
            Text("Guide")
                .modifier(TitleModifier(size: 18, color: .white))
                .frame(width: 57)
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
    GuideView()
}
