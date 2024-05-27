//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ThunderViewModel()
    @State var rotation: CGFloat = 0.0
    @State private var showGod = false
    @State private var selectedSegment: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    HeaderView().padding(.bottom, 54)
                    Button(action: {
                        manager.coins = 0
                        manager.hearts = 0
                    }, label: {
                        Text("Delete All").gradientButton()
                    })
                    Spacer()
                    MagicWheel()
                    Image("God")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(showGod ? 1.0 : 2.0)
                        .padding(.bottom, -50)
                    
                    BlureBottomView()
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                    showGod = true
                }
            }
        }.navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    dismiss()
                }
            } label: {
                Image("back")
            }
            
            Text("Magic Wheel")
                .modifier(TitleModifier(size: 18, color: .white))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            CoinsBalanceView(isCoins: true, score: "\(manager.coins)")
            CoinsBalanceView(isCoins: false, score: "\(manager.hearts)")
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.navigation)
    }
    
    @ViewBuilder
    func MagicWheel() -> some View {
        ZStack {
            Image("wheelBG")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
                .overlay {
                    RotateWheelView(rotation: $rotation, selectedSegment: $selectedSegment)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        .rotationEffect(.radians(rotation))
                        .animation(.easeInOut(duration: 1.5), value: rotation)
                        .overlay {
                            Button {
                                let randomAmount = Double(Int.random(in: 7..<50))
                                rotation += randomAmount
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    updateCoinsOrHearts()
                                }
                            } label: {
                                ZStack {
                                    Image("spin")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(100)
                                    Text("Spin").modifier(TitleModifier(size: 15, color: .white))
                                }
                            }
                            .overlay(
                                Image("drop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50) // Adjust the size as needed
                                    .offset(y: -20), // Adjust the offset to position the drop image correctly
                                alignment: .top
                            )
                        }
                }
        }
    }
  
    private func updateCoinsOrHearts() {
            let segmentValue = Int(selectedSegment)
            if selectedSegment % 2 == 0 {
                manager.coins += segmentValue
            } else {
                manager.hearts += segmentValue
            }
        }
}
