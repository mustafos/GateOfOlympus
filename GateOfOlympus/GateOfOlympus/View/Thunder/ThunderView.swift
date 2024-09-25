//
//  ThunderBallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct ThunderView: View {
    @Binding var rootView: Bool
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @State private var isAnimateNextLevel = false
    @State private var extraMoves: Bool = false
    @State private var extraTime: Bool = false
    @State private var animatingAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            Spacer()
            Image("NextLevel")
                .scaleEffect(isAnimateNextLevel ? 1.2 : 1.0)
            
            Image(thunderManager.score >= 1000 ? "win" : "lose")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .padding(.top, 8)
            
            HStack {
                MoveGuideButton(isGuide: false)
                    .frame(width: 64, height: 74)
                    .onTapGesture {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            extraMoves.toggle()
                        }
                    }
                
                Spacer()
                
                NavigationLink {
                    GuideView().navigationBarBackButtonHidden()
                } label: {
                    MoveGuideButton(isGuide: true)
                        .frame(width: 64, height: 74)
                }
            }.padding(.horizontal, 20)
            
            ZStack {
                Image("God")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .padding(.top, -260)
                
                ThunderGridView()
                    .environmentObject(thunderManager)
                    .environmentObject(musicPlayer)
                    .padding()
                    .overlay {
                        if thunderManager.combo != 0 {
                            withAnimation(.linear(duration: 0.4)) {
                                ZStack {
                                    Image("greenShadow")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 172)
                                    
                                    Text("+\(thunderManager.combo) points")
                                        .modifier(TitleModifier(size: 18, color: .white))
                                        .shadow(radius: 10)
                                }
                                .onAppear {
                                    musicPlayer.playSound(sound: "slot", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                                }
                            }
                        }
                    }
            }
            
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .background {
            Image("backgroundThunder")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity(1.0)
        }
        .blur(radius: $extraMoves.wrappedValue || $extraTime.wrappedValue ? 5 : 0, opaque: false)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimateNextLevel = true
                NotificationManager.shared.timeNotification()
            }
        }
        .overlay {
            if $extraMoves.wrappedValue || thunderManager.movesCount == 1 {
                ExtraAlert(isMoves: true)
            }
            
            if $extraTime.wrappedValue {
                ExtraAlert(isMoves: false)
            }
            
            if thunderManager.showResult {
                WinLoseAlert(isWin: thunderManager.score >= 1000)
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    Configurations.feedback.impactOccurred()
                    musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                    dismiss()
                    thunderManager.timerStop()
                }
            } label: {
                Image("back")
            }
            
            Spacer()
            
            TimerView()
            
            CoinsBalanceView(isCoins: true, score: "\(thunderManager.coins)")
            CoinsBalanceView(isCoins: false, score: "\(thunderManager.hearts)")
        }
        .padding(.horizontal, 36)
        .padding(.top, Device.iPad ? 58 : 36)
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
                .frame(width: 100 - CGFloat(Double(thunderManager.gameTimeLast)), height: 16)
                .foregroundColor(thunderManager.gameTimeLast <= 15 ? Color.love : Color.sea)
        }
        .overlay(alignment: .leading) {
            Image("time")
                .resizable()
                .scaledToFill()
                .frame(width: 22)
                .offset(x: -12, y: -4)
        }
        .onTapGesture {
            withAnimation {
                Configurations.feedback.impactOccurred()
                extraTime.toggle()
            }
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
                            withAnimation {
                                Configurations.feedback.impactOccurred()
                                musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                                thunderManager.hearts -= 5
                                thunderManager.movesCount += 5
                            }
                        } else {
                            withAnimation {
                                Configurations.feedback.impactOccurred()
                                musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                                thunderManager.gameTimeLast += 10
                                thunderManager.coins -= 100
                            }
                        }
                    } label: {
                        Text("Buy").gradientButton()
                    }
                }
                .padding(15)
                .overlay(Button {
                    withAnimation {
                        Configurations.feedback.impactOccurred()
                        if isMoves {
                            extraMoves.toggle()
                        } else {
                            extraTime.toggle()
                        }
                        animatingAlert.toggle()
                    }
                } label: {
                    Image("cancel")
                }, alignment: .topTrailing)
            }
            .textAreaConteiner(background: .accent, corner: 30)
            .padding(.horizontal, 70)
            .opacity($animatingAlert.wrappedValue ? 1 : 0)
            .offset(y: $animatingAlert.wrappedValue ? 0 : -100)
            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: extraMoves)
            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: extraTime)
            .onAppear(perform: {
                musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
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
                            Text("\(thunderManager.score)")
                        }
                        .frame(height: 24)
                        .modifier(TitleModifier(size: 14, color: .white))
                    }
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            
                            if isWin {
                                thunderManager.gameStart()
                                thunderManager.coins = thunderManager.score
                            } else {
                                thunderManager.gameStart()
                            }
                        }
                    } label: {
                        Text(isWin ? "Naxt Level" : "Play Again").gradientButton()
                    }.padding(.bottom, -4)
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            thunderManager.showResult = false
                        }
                    } label: {
                        Text("Home").gradientButton()
                    }
                }.padding(15)
            }
            .textAreaConteiner(background: .accentColor, corner: 30)
            .shadow(color: isWin ? .green : .red, radius: 50)
            .padding(.horizontal, 70)
            .onAppear(perform: {
                musicPlayer.playSound(sound: "win", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
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
                    Text("\(thunderManager.movesCount)").modifier(TitleModifier(size: 18, color: .white))
                }
            }.modifier(BodyModifier(size: 12, color: .white))
        }.textAreaConteiner(background: Color.black.opacity(0.9), corner: 10)
    }
}
