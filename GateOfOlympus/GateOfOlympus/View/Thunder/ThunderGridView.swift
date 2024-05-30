//
//  ThunderGridView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct ThunderGridView: View {
    @ObservedObject var manager: ThunderViewModel
    @StateObject private var musicPlayer = AudioPlayer()
    @State private var startDetectDrag = false
    @State private var isAnimateStart = false
    private let haptics = UINotificationFeedbackGenerator()
    var body: some View {
        ZStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 6), count: 5), spacing: 6) {
                ForEach(0..<30) { index in
                    GeometryReader { geo in
                        Rectangle()
                            .frame(width: nil, height: geo.size.width)
                            .foregroundColor(Color(red: 71/255, green: 14/255, blue: 115/255))
                            .cornerRadius(10)
                            .overlay {
                                if manager.grids[index].gridType != .blank && !manager.isStop {
                                    Image(manager.grids[index].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .gesture(dragGesture(index: index))
                                }
                            }
                    }.aspectRatio(contentMode: .fit)
                }
            }
            .background(
                Image("slot")
                    .resizable()
                    .scaledToFill()
                    .padding(-20)
            )
            .padding(56)
            .overlay {
                if !manager.isPlaying {
                    Button {
                        manager.gameStart()
                    } label: {
                        Image("mover")
                            .scaleEffect(isAnimateStart ? 1.2 : 1.0)
                    }
                    .onAppear() {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            isAnimateStart = true
                        }
                    }
                }
                if manager.isStop {
                    VStack(spacing: 15) {
                        WinLoseAlert(isWin: manager.score >= 100)
                    }
                }
            }
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
                            Text("\(manager.score)")
                        }
                        .frame(height: 24)
                        .modifier(TitleModifier(size: 14, color: .white))
                    }
                    
                    Button {
                        withAnimation {
                            feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            if isWin {
                                manager.timerStart()
                                manager.coins = manager.score
                            } else {
                                manager.gameStart()
                            }
                        }
                    } label: {
                        Text(isWin ? "Naxt Level" : "Play Again").gradientButton()
                    }.padding(.bottom, -4)
                    
                    Button {
                        withAnimation {
                            feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            //                            rootView = false
                        }
                    } label: {
                        Text("Home").gradientButton()
                    }
                }
                .padding(15)
            }
            .textAreaConteiner(background: .accentColor, corner: 30)
            //            .opacity($animatingAlert.wrappedValue ? 1 : 0)
            //            .offset(y: $animatingAlert.wrappedValue ? 0 : -100)
            .shadow(color: isWin ? .green : .red, radius: 100)
            //            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: showResults)
            //            .onAppear(perform: {
            //                self.animatingAlert = true
            //            })
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func dragGesture(index: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if startDetectDrag && !manager.isProcessing && manager.isPlaying && !manager.isStop {
                    if value.translation.width > 5 { // swipe right
                        if !stride(from: 4, through: 29, by: 5).contains(index) {
                            let rightIndex = index + 1
                            processMove(leftIndex: index, rightIndex: rightIndex)
                        }
                        startDetectDrag = false
                    } else if value.translation.width < -5 { // swipe left
                        if !stride(from: 0, through: 25, by: 5).contains(index) {
                            let leftIndex = index - 1
                            processMove(leftIndex: leftIndex, rightIndex: index)
                        }
                        startDetectDrag = false
                    } else if value.translation.height < -5 { // swipe up
                        if index >= 5 {
                            let upIndex = index - 5
                            processMove(leftIndex: upIndex, rightIndex: index)
                        }
                        startDetectDrag = false
                    } else if value.translation.height > 5 { // swipe down
                        if index <= 24 {
                            let downIndex = index + 5
                            processMove(leftIndex: index, rightIndex: downIndex)
                        }
                        startDetectDrag = false
                    }
                } else {
                    if value.translation == .zero {
                        startDetectDrag = true
                    }
                }
            }
    }
    
    func processMove(leftIndex: Int, rightIndex: Int) {
        manager.isMatch = false
        manager.isProcessing = true
        withAnimation(.easeInOut(duration: 0.4)) {
            haptics.notificationOccurred(.success)
            musicPlayer.playSound(sound: "coins", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
            manager.grids.swapAt(leftIndex, rightIndex)
        }
        let left = manager.grids[leftIndex].gridType
        let right = manager.grids[rightIndex].gridType
        
        if [left, right].allSatisfy({ $0 == .gift }) {
            manager.clearAll()
        } else if left == .gift && right == .bomb || left == .bomb && right == .gift {
            manager.manyBomb(first: leftIndex, second: rightIndex)
        } else if left == .gift && right == .row || left == .row && right == .gift {
            manager.manyRow(first: leftIndex, second: rightIndex)
        } else if left == .gift && right == .column || left == .column && right == .gift {
            manager.manyColumn(first: leftIndex, second: rightIndex)
        } else if [left, right].allSatisfy({ $0 == .bomb }) {
            manager.bigBomb(first: leftIndex, second: rightIndex)
        } else if [.row, .column].contains(left) && right == .bomb || left == .bomb && [.row, .column].contains(right) {
            manager.bigCross(first: leftIndex, second: rightIndex)
        } else if [.row, .column].contains(left) && [.row, .column].contains(right) {
            manager.cross(first: leftIndex, second: rightIndex)
        } else if left == .gift {
            manager.gift(gridType: right, index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if right == .gift {
            manager.gift(gridType: left, index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if left == .bomb {
            manager.bomb(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if right == .bomb {
            manager.bomb(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if left == .row {
            manager.row(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if right == .row {
            manager.row(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if left == .column {
            manager.column(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else if right == .column {
            manager.column(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                manager.fallDown()
            }
        } else {
            manager.checkMatch()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !manager.isMatch {
                withAnimation(.easeInOut(duration: 0.4)) {
                    haptics.notificationOccurred(.error)
                    musicPlayer.playSound(sound: "coins", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                    manager.grids.swapAt(leftIndex, rightIndex)
                }
            }
        }
    }
}
