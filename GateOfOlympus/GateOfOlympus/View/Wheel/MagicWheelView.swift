//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    @State var rotation: CGFloat = 0.0
    @State private var showGod = false
    @State private var coins: Int = UserDefaults.standard.integer(forKey: "Coins")
    @State private var hearts: Int = UserDefaults.standard.integer(forKey: "Hearts")
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    HeaderView().padding(.bottom, 54)
                    Button(action: {
                        coins = 0
                        hearts = 0
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
                .minimumScaleFactor(0.75)
            
            CoinsBalanceView(isCoins: true, score: "\(coins)")
            CoinsBalanceView(isCoins: false, score: "\(hearts)")
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
                    RotateWheelView(rotation: $rotation)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        .rotationEffect(.radians(rotation))
                        .animation(.easeInOut(duration: 1.5), value: rotation)
                        .overlay {
                            Button {
                                let randomAmount = Double(Int.random(in: 7..<50))
                                rotation += randomAmount
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
}
