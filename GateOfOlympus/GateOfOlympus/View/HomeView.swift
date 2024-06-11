//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var manager = ThunderViewModel()
    @StateObject private var musicPlayer = AudioPlayer()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var rootView: Bool = false
    @State private var showImage = false
    
    @State private var randomCoinsRubin = Int.random(in: 0...5)
    @State private var randomCoinsCrown = Int.random(in: 0...5)
    @State private var randomCoinsDiamond = Int.random(in: 0...5)
    @State private var randomCoinsHeart = Int.random(in: 0...5)
    
    var body: some View {
        if manager.isUserLogin == true {
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
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                CombinationesView()
                                
                                NavigationLink {
                                    ThunderView(rootView: $rootView).navigationBarBackButtonHidden()
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
                        .refreshable {
                            updateRandomCoins()
                        }
                        Spacer()
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                        showImage = true
                        musicPlayer.playBackgroundMusic(fileName: "olympus", fileType: "mp3", isMusicOn: musicPlayer.isMusicOn)
                    }
                }
            }.navigationViewStyle(.stack)
        } else {
            OnboardingView()
        }
    }
    
    @ViewBuilder
    func NavigationBar() -> some View {
        HStack(spacing: 20) {
            NavigationLink {
                SettingsView().navigationBarBackButtonHidden()
            } label: {
                Image("gear")
            }
            
            Text("Olympus")
                .modifier(TitleModifier(size: 18, color: .white))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            CoinsBalanceView(isCoins: true, score: "\(manager.coins)")
            CoinsBalanceView(isCoins: false, score: "\(manager.hearts)")
        }
        .frame(maxWidth: .infinity)
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
                    Text("\(randomCoinsRubin)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("crown").badge {
                    Text("\(randomCoinsCrown)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("diamond").badge {
                    Text("\(randomCoinsDiamond)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("heart").badge {
                    Text("\(randomCoinsHeart)").modifier(BodyModifier(size: 14, color: .white))
                }
            }
        }
    }
    
    private func updateRandomCoins() {
        randomCoinsRubin = Int.random(in: 0...5)
        randomCoinsCrown = Int.random(in: 0...5)
        randomCoinsDiamond = Int.random(in: 0...5)
        randomCoinsHeart = Int.random(in: 0...5)
    }
}

#Preview {
    HomeView()
}
