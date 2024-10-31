//
//  GameCellContainer.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct GameCellContainer: View {
    var isWheel: Bool
    var isShop: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                if isShop {
                    Text("Play to the max!").modifier(TitleModifier(size: 18, color: .white))
                    Text("Shop Now")
                        .gradientButton()
                        .frame(width: 130)
                } else {
                    Text(isWheel ? "Magic Wheel" : "God of Thunder").modifier(TitleModifier(size: 18, color: .white))
                    Text(isWheel ? "Ready" : "Start Play")
                        .gradientButton()
                        .frame(width: 130)
                }
            }
            Spacer()
        }
        .frame(height: 124)
        .padding(.horizontal, 20)
        .background {
            if isShop {
                Image("shoper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else {
                Image(isWheel ? "wheel" : "thunder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
        }
        .cornerRadius(20)
    }
}
