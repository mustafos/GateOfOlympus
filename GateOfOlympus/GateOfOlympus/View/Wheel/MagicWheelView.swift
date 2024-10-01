//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

enum TypeRevard: String {
    case coins = "WheelCoinsColor"
    case hearts = "WheelHeartsColor"
    case empty
}

struct Sector: Equatable {
    let point: Int
    let type: TypeRevard
}


struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
    @State private var showGod = false
    @State private var showWins = false
    
    @State private var isAnimating = false
    @State private var spinDegrees = 0.0
    @State private var rand = 0.0
    @State private var newAngle = 0.0
    @State private var rotation: CGFloat = 0.0
    @State private var selectedSegment: Int = 0
    @State private var selectedSector: Sector = Sector(point: 0, type: .coins)
    
    private let halfSector = 360.0 / 11.0 / 2.0
    private let sectors: [Sector] = [
        Sector(point: 10, type: .hearts),
        Sector(point: 4, type: .coins),
        Sector(point: 20, type: .hearts),
        Sector(point: 0, type: .coins),
        Sector(point: 0, type: .hearts),
        Sector(point: 1, type: .coins),
        Sector(point: 100, type: .hearts),
        Sector(point: 2, type: .coins),
        Sector(point: 10, type: .hearts),
        Sector(point: 3, type: .coins),
        Sector(point: 50, type: .hearts)
    ]
    
    private var spinAnimation: Animation {
        Animation.easeOut(duration: 3.0)
            .repeatCount(1, autoreverses: false)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent.ignoresSafeArea()
            VStack(spacing: 0) {
                HeaderView(image: "back", title: "Spin") {
                    dismiss()
                }
                .padding(.bottom, 54)
                VStack(spacing: 0) {
                    magicWheel
                    Image("God")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(showGod ? 1.0 : 2.0)
                        .padding(.bottom, -50)
                    
                    BlureBottomView()
                }
                .onChange(of: spinDegrees) { newValue in
                    newAngle = getAngle(angle: spinDegrees)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                    showGod = true
                }
            }
        }
    }
}

private extension MagicWheelView {
    
    // MARK: Components
    var magicWheel: some View {
        ZStack {
            Image("wheelBG")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
                .overlay {
                    RotateWheelView(rotation: $rotation, selectedSegment: $selectedSegment)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        .rotationEffect(Angle(degrees: spinDegrees))
                        .animation(spinAnimation, value: rotation)
                        .overlay {
                            Button {
                                withAnimation {
                                    musicPlayer.playSound(sound: "wheel", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                                    isAnimating = true
                                    rand = Double.random(in: 1...360)
                                    spinDegrees += 720.0 + rand
                                    newAngle = getAngle(angle: spinDegrees)
                                    rotation = CGFloat(spinDegrees * .pi / 180)
                                    selectedSector = sectorFromAngle(angle: newAngle)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                                        updateCoinsOrHearts()
                                        isAnimating = false
                                        showWins = true
                                    }
                                }
                            } label: {
                                spinButton
                            }
                            .disabled(isAnimating)
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
    
    var spinButton: some View {
        ZStack {
            Image("spin")
                .resizable()
                .scaledToFit()
                .frame(minWidth: 50, idealWidth: 100, maxWidth: 120)
                .padding(Device.iPad ? 150 : 100)
            Text("Spin").modifier(TitleModifier(size: 15, color: .white))
                .overlay {
                    if showWins && newAngle != 0 {
                        ZStack {
                            Image("greenShadow")
                                .frame(maxWidth: 100)
                            HStack {
                                Image(selectedSector.type == .coins ? "coin" : "love")
                                Text("\(selectedSector.point)")
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
    
    // MARK: Properties
    func getAngle(angle: Double) -> Double {
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        return deg
    }
    
    func sectorFromAngle(angle: Double) -> Sector {
        var i = 0
        var sector: Sector = Sector(point: -1, type: .empty)
        
        while sector == Sector(point: -1, type: .empty) && i < sectors.count {
            let start: Double = halfSector * Double((i * 2 + 1)) - halfSector
            let end: Double = halfSector * Double((i * 2 + 10))
            
            if angle >= start && angle < end {
                sector = sectors[i]
            }
            i += 1
        }
        
        return sector
    }
    
    // MARK: Methods
    func updateCoinsOrHearts() {
        if selectedSector.type == .coins {
            thunderManager.coins += selectedSector.point
        } else {
            thunderManager.hearts += selectedSector.point
        }
        musicPlayer.playSound(sound: "win", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
    }
}
