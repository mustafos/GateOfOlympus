//
//  ThunderHeaderView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct ThunderHeaderView: View {
    @ObservedObject var manager: ThunderViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationBar()
    }
    
    @ViewBuilder
    func NavigationBar() -> some View {
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
