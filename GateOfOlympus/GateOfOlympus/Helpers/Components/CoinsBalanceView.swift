//
//  CoinsBalanceView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct CoinsBalanceView: View {
    var isCoins: Bool
    var score: String
    @StateObject var manager = ThunderViewModel()
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(score)
                    .modifier(TitleModifier(size: 12, color: .white))
                    .padding(.trailing, 10)
            }
            .frame(width: 72, height: 20)
            .background(
                Capsule()
                    .foregroundColor(Color.black.opacity(0.7))
            )
            .overlay(alignment: .leading) {
                Image(isCoins ? "coin" : "love")
                    .offset(x: -12, y: 0)
            }
        }
        .onAppear {
            if manager.coins <= 0 {
                manager.coins += 100
            }
            if manager.hearts <= 0 {
                manager.hearts += 15
            }
        }
    }
}

#Preview {
    CoinsBalanceView(isCoins: false, score: "100")
}
