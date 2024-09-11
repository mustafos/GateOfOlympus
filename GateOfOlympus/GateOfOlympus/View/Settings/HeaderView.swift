//
//  HeaderView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 08.06.2024.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
   
    var image: String
    var title: String
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            BannerView()
            HStack(spacing: 20) {
                Button {
                    withAnimation {
                        Configurations.feedback.impactOccurred()
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
                
                CoinsBalanceView(isCoins: true, score: "\(thunderManager.coins)")
                CoinsBalanceView(isCoins: false, score: "\(thunderManager.hearts)")
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }.background(Color.navigation)
    }
}

#Preview {
    HeaderView(image: "back", title: "Settings") {
        print("Action")
    }
}
