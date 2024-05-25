//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var manager = ThunderViewModel()
    @AppStorage("isOnboarding") var isUserLogin: Bool?
//    @AppStorage("Coins") var coins: Int = 0
//    @AppStorage("Hearts") var hearts: Int = 0
    @Environment(\.dismiss) var dismiss
    @State private var musicOff: Bool = false
    @State private var soundOff: Bool = false
    @State private var showImage = false
    
    var body: some View {
        if isUserLogin == true {
            NavigationView {
                ZStack(alignment: .bottom) {
                    Color.accentColor.ignoresSafeArea()
                    Image("God")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(showImage ? 1.0 : 2.0)
                        .padding(.bottom, -50)
                    
                    BlureBottomView()
                    
                    VStack(spacing: 0) {
                        NavigationBar()
                        
                        Button {
                            isUserLogin = false
                        } label: {
                            Text("Logout").gradientButton()
                        }
                        
                        Button {
                            manager.coins += 1
                            manager.hearts += 1
                        } label: {
                            Text("Add").gradientButton()
                        }
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                CombinationesView()
                                
                                NavigationLink {
                                    ThunderView().navigationBarBackButtonHidden()
                                } label: {
                                    GameCellContainer(isWheel: false)
                                }
                                
                                NavigationLink {
                                    MagicWheelView().navigationBarBackButtonHidden()
                                } label: {
                                    GameCellContainer(isWheel: true)
                                }
                            }.padding(20)
                        }
                        Spacer()
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .onAppear() {
                    withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                        showImage = true
                    }
                }
            }
            .navigationViewStyle(.stack)
        } else {
            OnboardingView()
        }
    }
    
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    musicOff.toggle()
                }
            } label: {
                Image(musicOff ? "musicOff" : "music")
            }
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    soundOff.toggle()
                }
            } label: {
                Image(soundOff ? "soundOff" : "sound")
            }
            Spacer()
            CoinsBalanceView(isCoins: true, score: "\(manager.coins)")
            CoinsBalanceView(isCoins: false, score: "\(manager.hearts)")
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.navigation)
    }
    
    @ViewBuilder
    func CombinationesView() -> some View {
        VStack(alignment: .leading) {
            Text("Last Combinationes")
                .modifier(TitleModifier(size: 18, color: .white))
            HStack(spacing: 38) {
                Image("rubin").badge {
                    Text("4").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("crown").badge {
                    Text("1").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("diamond").badge {
                    Text("2").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("heart").badge {
                    Text("3").modifier(BodyModifier(size: 14, color: .white))
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
