//
//  ThunderBallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct ThunderView: View {
    @StateObject var manager = ThunderViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ThunderHeaderView(manager: manager)
                ResultsBoardView(manager: manager)
                ThunderGridView(manager: manager)
                
                if manager.combo != 0 {
                    withAnimation(.linear(duration: 0.4)) {
                        Text("Combo ")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
                        +
                        Text("\(manager.combo)")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
                        +
                        Text(" !")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
                    }
                }
                Spacer()
            }
            .background(
                Image("backgroundThunder")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}
