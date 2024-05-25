//
//  ResultsBoardView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//
//
//import SwiftUI
//
//struct ResultsBoardView: View {
//    
//    @ObservedObject var manager: ThunderViewModel
//    
//    var body: some View {
//        HStack(spacing: 16) {
//            VStack {
//                Text("SCORE")
//                    .bold()
//                    .font(.title2)
//                    .foregroundColor(Color(red: 240/255, green: 224/255, blue: 213/255))
//                
//                Text("\(manager.score)")
//                    .bold()
//                    .font(.title)
//                    .foregroundColor(.white)
//            }
//            .padding(.vertical, 8)
//            .frame(maxWidth: .infinity)
//            .background(Color(red: 187/255, green: 174/255, blue: 161/255))
//            .cornerRadius(5)
//            
//            VStack {
//                Text("BEST")
//                    .bold()
//                    .font(.title2)
//                    .foregroundColor(Color(red: 240/255, green: 224/255, blue: 213/255))
//                
//                Text("\(manager.bestScore)")
//                    .bold()
//                    .font(.title)
//                    .foregroundColor(.white)
//            }
//            .padding(.vertical, 8)
//            .frame(maxWidth: .infinity)
//            .background(Color(red: 187/255, green: 174/255, blue: 161/255))
//            .cornerRadius(5)
//        }
//    }
//}
