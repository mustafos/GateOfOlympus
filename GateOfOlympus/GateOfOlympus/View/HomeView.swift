//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @Environment(\.dismiss) var dismiss
    
    @State private var rootView: Bool = false
    @State private var showImage = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accent.ignoresSafeArea()
                Image("God")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(showImage ? 1.0 : 2.0)
                    .padding(.bottom, -50)
                
                BlureBottomView()
                
                VStack(spacing: 0) {
                    NavigationBar()
                    
                    VStack(spacing: 20) {
                        CombinationesView()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            NavigationLink {
                                ThunderView(rootView: $rootView)
                                    .environmentObject(thunderManager)
                                    .environmentObject(musicPlayer)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                GameCellContainer(isWheel: false, isShop: false)
                            }
                            
                            NavigationLink {
                                MagicWheelView()
                                    .environmentObject(thunderManager)
                                    .environmentObject(musicPlayer)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                GameCellContainer(isWheel: true, isShop: false)
                            }
                            
                            NavigationLink {
                                PaywallView()
                                    .environmentObject(thunderManager)
                                    .environmentObject(musicPlayer)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                GameCellContainer(isWheel: false, isShop: true)
                            }
                        }
                        .refreshable {
                            // TODO: Update data if scroll up
                        }
                    }.padding(20)
                    
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                    showImage = true
                    musicPlayer.playBackgroundMusic(fileName: "olympus", fileType: "mp3", isMusicOn: musicPlayer.isMusicOn)
                }
            }
        }.navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func NavigationBar() -> some View {
        VStack(spacing: 0) {
            BannerView()
            HStack(spacing: 20) {
                NavigationLink {
                    SettingsView()
                        .environmentObject(thunderManager)
                        .environmentObject(musicPlayer)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image("gear")
                }
                
                Text("Olympus")
                    .modifier(TitleModifier(size: 18, color: .white))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                Spacer()
                
                CoinsBalanceView(isCoins: true, score: "\(thunderManager.coins)")
                CoinsBalanceView(isCoins: false, score: "\(thunderManager.hearts)")
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }.background(Color.navigation)
    }
    
    @ViewBuilder
    func CombinationesView() -> some View {
        VStack(alignment: .leading) {
            Text("Your VIP Pass to Big Wins!")
                .modifier(TitleModifier(size: 18, color: .white))
            HStack(spacing: 38) {
                Image("rubin").badge {
                    Text("\(thunderManager.rubinCollect)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("crown").badge {
                    Text("\(thunderManager.crownCollect)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("diamond").badge {
                    Text("\(thunderManager.diamondCollect)").modifier(BodyModifier(size: 14, color: .white))
                }
                Image("heart").badge {
                    Text("\(thunderManager.heartCollect)").modifier(BodyModifier(size: 14, color: .white))
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
