//
//  ThunderHeaderView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct ThunderHeaderView: View {
    
    @ObservedObject var manager: ThunderViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Text("Candy Crush")
                .bold()
                .font(.largeTitle)
                .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
            
            Spacer()
            
            Button {
                manager.timerStop()
            } label: {
                Image(systemName: "pause.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
            }
        }
    }
}
