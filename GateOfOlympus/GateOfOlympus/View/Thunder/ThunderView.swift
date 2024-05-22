//
//  ThunderBallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct ThunderView: View {
    @StateObject var manager = ThunderViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
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
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .background(
                Image("backgroundThunder")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }.navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    dismiss()
                    manager.timerStop()
                }
            } label: {
                Image("menu")
            }
            
            Spacer()
            
            TimerView()
            CoinsBalanceView(isCoins: true, score: "100")
            CoinsBalanceView(isCoins: false, score: "14")
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.navigation)
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(width: 104, height: 20)
                .foregroundColor(Color.black.opacity(0.7))
            
            Capsule()
                .frame(width: 100 - CGFloat(Double(manager.gameTimeLast)), height: 16)
                .foregroundColor(manager.gameTimeLast <= 15 ? Color.love : Color.sea)
        }
    }
}
