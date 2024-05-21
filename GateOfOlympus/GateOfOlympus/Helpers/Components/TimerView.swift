//
//  TimerView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var manager: ThunderViewModel
    
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(height: 40)
                .foregroundColor(Color(red: 240/255, green: 224/255, blue: 213/255))
            
            Capsule()
                .frame(width: (geometry.size.width-32)*CGFloat(Double(manager.gameTimeLast)/120.0), height: 40)
                .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
                .overlay(alignment: .trailing) {
                    if manager.gameTimeLast > 15 {
                        Text("\(manager.gameTimeLast)")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                    }
                }
        }
        .overlay(alignment: .leading) {
            if manager.gameTimeLast <= 15 {
                Text("\(manager.gameTimeLast)")
                    .bold()
                    .font(.title)
                    .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
                    .padding(.leading, 8)
            }
        }
    }
}
