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
    @StateObject private var musicPlayer = AudioPlayer()
    @State var rotation: CGFloat = 0.0
    @State private var showGod = false
    @State private var selectedSegment: Int = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accentColor.ignoresSafeArea()
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
                                musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
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
