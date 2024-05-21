//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isOnboarding") var isUserLogin: Bool?
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
                    withAnimation(.easeInOut(duration: 1.0).repeatCount(1) /*.repeatForever(autoreverses: true)*/) {
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
            CoinsBalanceView(isCoins: true, score: "100")
            CoinsBalanceView(isCoins: false, score: "14")
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 38) {
                    Image("rubin")
                    Image("diamond")
                    Image("heart")
                    Image("crown")
                    Image("bowl")
                    Image("ring")
                    Image("trophy")
                    Image("amulet")
                }
            }
        }//.padding(.horizontal, 20)
    }
}

#Preview {
    HomeView()
}
