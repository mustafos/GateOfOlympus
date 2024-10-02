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
    @StateObject private var musicPlayer = AudioPlayer()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent.ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView(image: "back", title: "Guide") {
                    dismiss()
                }.padding(.bottom, 34)
                
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
    }
}

#Preview {
    GuideView()
}
