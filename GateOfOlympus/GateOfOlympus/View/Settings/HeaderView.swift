//
//  HeaderView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 08.06.2024.
//

import SwiftUI

struct HeaderView: View {
    @StateObject var manager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    var image: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                    action()
                }
            } label: {
                Image(image)
            }
            
            Text(title)
                .modifier(TitleModifier(size: 16, color: .white))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            Spacer(minLength: 5)
            
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
    HeaderView(image: "back", title: "Settings") {
        print("Action")
    }
}
