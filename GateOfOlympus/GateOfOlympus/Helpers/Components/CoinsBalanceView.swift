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
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Image(isCoins ? "coin" : "love")
                Text(score)
                    .modifier(TitleModifier(size: 12, color: .white))
            }
            .padding(.trailing, 10)
            .frame(width: .infinity, height: 20)
            .background(
                Capsule()
                    .foregroundColor(Color.black.opacity(0.7))
            )
        }
    }
}

#Preview {
    CoinsBalanceView(isCoins: false, score: "100")
}
