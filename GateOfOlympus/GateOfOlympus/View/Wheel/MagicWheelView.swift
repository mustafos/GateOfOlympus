//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @State var rotation: CGFloat = 0.0
    @State private var showGod = false
    @State private var showWins = false
    @State private var selectedSegment: Int = 0
    
    private let segmentValue1 = [0, 100, 10, 50, 10, 20].randomElement()!
    private let segmentValue2 = [0, 1, 2, 3, 0, 4].randomElement()!
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent.ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView(image: "back", title: "Spin") {
                    dismiss()
                }
                .padding(.bottom, 54)
                VStack(spacing: 0) {
                    MagicWheel()
                    Image("God")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(showGod ? 1.0 : 2.0)
                        .padding(.bottom, -50)
                    
                    BlureBottomView()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                    showGod = true
                    NotificationManager.shared.timeNotification()
                }
            }
        }
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
                                musicPlayer.playSound(sound: "wheel", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                                let randomAmount = Double(Int.random(in: 7..<50))
                                rotation += randomAmount
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    updateCoinsOrHearts()
                                    showWins = true
                                }
                            } label: {
                                ZStack {
                                    Image("spin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 50, idealWidth: 100, maxWidth: 120)
                                        .padding(Device.iPad ? 150 : 100)
                                    Text("Spin").modifier(TitleModifier(size: 15, color: .white))
                                        .overlay {
                                            if showWins && (segmentValue1 != 0 || segmentValue2 != 0) {
                                                ZStack {
                                                    Image("greenShadow")
                                                        .frame(maxWidth: 100)
                                                    HStack {
                                                        Image(selectedSegment % 2 == 0 ? "coin" : "love")
                                                        Text(selectedSegment % 2 == 0 ? "\(segmentValue1)" : "\(segmentValue2)")
                                                            .modifier(TitleModifier(size: 18, color: .white))
                                                            .shadow(radius: 10)
                                                    }
                                                }
                                                .onTapGesture {
                                                    showWins.toggle()
                                                }
                                            }
                                        }
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
        if selectedSegment % 2 == 0 {
            thunderManager.coins += segmentValue1
            musicPlayer.playSound(sound: "win", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
        } else {
            thunderManager.hearts += segmentValue2
            musicPlayer.playSound(sound: "win", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
        }
    }
}
