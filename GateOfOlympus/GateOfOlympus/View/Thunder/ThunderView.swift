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
    @State private var isAnimateNextLevel = false
    @State private var extraMoves: Bool = false
    @State private var extraTime: Bool = false
    @State private var showResults: Bool = false
    @State private var animatingAlert: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundThunder")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HeaderView()
                    
                    Image("NextLevel")
                        .scaleEffect(isAnimateNextLevel ? 1.2 : 1.0)
                    
                    HStack {
                        MoveGuideButton(isGuide: false)
                            .onTapGesture {
                                withAnimation {
                                    feedback.impactOccurred()
                                    extraMoves.toggle()
                                }
                            }
                        Spacer()
                        NavigationLink {
                            GuideView().navigationBarBackButtonHidden()
                        } label: {
                            MoveGuideButton(isGuide: true)
                        }
                    }
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
                .blur(radius: $extraMoves.wrappedValue ? 5 : 0, opaque: false)
                .onAppear() {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isAnimateNextLevel = true
                    }
                }
                
                if $extraMoves.wrappedValue {
                    ExtraAlert(isMoves: true)
//                    WinLoseAlert(isWin: true)
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
    
    @ViewBuilder
    func ExtraAlert(isMoves: Bool) -> some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Image(isMoves ? "moves" : "time")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 74)
                    
                    Text("Extra \(isMoves ? "Moves" : "Time")")
                        .modifier(TitleModifier(size: 18, color: .white))
                    
                    Text(isMoves
                         ? "You can purchase 5 extra moves for 5 extra hearts"
                         : "You've run out of time. You can buy an additional 10 seconds for 100 coins")
                    .modifier(BodyModifier(size: 14, color: .white))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    
                    if isMoves {
                        HStack(spacing: 6) {
                            Image("moves")
                                .resizable()
                                .scaledToFit()
                            Text("5  =")
                            Image("love")
                                .resizable()
                                .scaledToFit()
                            Text("5")
                        }
                        .frame(height: 20)
                        .modifier(TitleModifier(size: 14, color: .white))
                    } else {
                        HStack(spacing: 6) {
                            Image("time")
                                .resizable()
                                .scaledToFit()
                            Text("10 sec  =")
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                            Text("100")
                        }
                        .frame(height: 20)
                        .modifier(TitleModifier(size: 14, color: .white))
                    }
                    
                    Button {
                        if isMoves {
                            extraMoves.toggle()
                            animatingAlert.toggle()
                        }
                    } label: {
                        Text("Buy").gradientButton()
                    }
                }
                .padding(15)
            }
            .textAreaConteiner(background: .accentColor, corner: 30)
            .padding(.horizontal, 70)
            .opacity($animatingAlert.wrappedValue ? 1 : 0)
            .offset(y: $animatingAlert.wrappedValue ? 0 : -100)
            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: extraMoves)
            .onAppear(perform: {
                self.animatingAlert = true
            })
        }
    }
    
    @ViewBuilder
    func WinLoseAlert(isWin: Bool) -> some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Image(isWin ? "win" : "lose")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 56)
                    
                    Text(isWin ? "You Win!" : "Game over")
                        .modifier(TitleModifier(size: 18, color: .white))
                    
                    if isWin {
                        HStack(spacing: 6) {
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                            Text("200")
                        }
                        .frame(height: 24)
                        .modifier(TitleModifier(size: 14, color: .white))
                    }
                    
                    Button {
                        showResults.toggle()
                        animatingAlert.toggle()
                        //                                self.activateBet10()
                        //                                self.coins = 100
                    } label: {
                        Text(isWin ? "Naxt Level" : "Play Again").gradientButton()
                    }.padding(.bottom, -4)
                    
                    Button {
                        showResults.toggle()
                        animatingAlert.toggle()
                    } label: {
                        Text("Home").gradientButton()
                    }
                }
                .padding(15)
            }
            .textAreaConteiner(background: .accentColor, corner: 30)
            .opacity($animatingAlert.wrappedValue ? 1 : 0)
            .offset(y: $animatingAlert.wrappedValue ? 0 : -100)
            .shadow(color: isWin ? .green : .red, radius: 100)
            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: showResults)
            .onAppear(perform: {
                self.animatingAlert = true
            })
        }
    }
    
    @ViewBuilder
    func MoveGuideButton(isGuide: Bool) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                if isGuide {
                    Image("book")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 74)
                    
                    Text("Guide")
                } else {
                    Image("moves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text("Moves")
                    Text("5").modifier(TitleModifier(size: 18, color: .white))
                }
            }.modifier(BodyModifier(size: 12, color: .white))
        }
        .textAreaConteiner(background: Color.black.opacity(0.9), corner: 10)
    }
}
