//
//  ThunderGridView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct ThunderGridView: View {
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @EnvironmentObject private var musicPlayer: AudioPlayer
    
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
                                if thunderManager.grids[index].gridType != .blank && !thunderManager.isStop {
                                    Image(thunderManager.grids[index].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .gesture(dragGesture(index: index))
                                }
                            }
                    }
                    .aspectRatio(contentMode: .fit)
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
                if !thunderManager.isPlaying {
                    Button {
                        thunderManager.gameStart()
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
            }
        }
    }
    
    func dragGesture(index: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if startDetectDrag && !thunderManager.isProcessing && thunderManager.isPlaying && !thunderManager.isStop {
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
        thunderManager.isMatch = false
        thunderManager.isProcessing = true
        withAnimation(.easeInOut(duration: 0.4)) {
            haptics.notificationOccurred(.success)
            musicPlayer.playSound(sound: "coins", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
            thunderManager.movesCount -= 1
            thunderManager.grids.swapAt(leftIndex, rightIndex)
        }
        let left = thunderManager.grids[leftIndex].gridType
        let right = thunderManager.grids[rightIndex].gridType
        
        if [left, right].allSatisfy({ $0 == .gift }) {
            thunderManager.clearAll()
        } else if left == .gift && right == .bomb || left == .bomb && right == .gift {
            thunderManager.manyBomb(first: leftIndex, second: rightIndex)
        } else if left == .gift && right == .row || left == .row && right == .gift {
            thunderManager.manyRow(first: leftIndex, second: rightIndex)
        } else if left == .gift && right == .column || left == .column && right == .gift {
            thunderManager.manyColumn(first: leftIndex, second: rightIndex)
        } else if [left, right].allSatisfy({ $0 == .bomb }) {
            thunderManager.bigBomb(first: leftIndex, second: rightIndex)
        } else if [.row, .column].contains(left) && right == .bomb || left == .bomb && [.row, .column].contains(right) {
            thunderManager.bigCross(first: leftIndex, second: rightIndex)
        } else if [.row, .column].contains(left) && [.row, .column].contains(right) {
            thunderManager.cross(first: leftIndex, second: rightIndex)
        } else if left == .gift {
            thunderManager.gift(gridType: right, index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if right == .gift {
            thunderManager.gift(gridType: left, index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if left == .bomb {
            thunderManager.bomb(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if right == .bomb {
            thunderManager.bomb(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if left == .row {
            thunderManager.row(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if right == .row {
            thunderManager.row(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if left == .column {
            thunderManager.column(index: leftIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else if right == .column {
            thunderManager.column(index: rightIndex)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                thunderManager.fallDown()
            }
        } else {
            thunderManager.checkMatch()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !thunderManager.isMatch {
                withAnimation(.easeInOut(duration: 0.4)) {
                    haptics.notificationOccurred(.error)
                    musicPlayer.playSound(sound: "coins", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                    thunderManager.movesCount -= 1
                    thunderManager.grids.swapAt(leftIndex, rightIndex)
                }
            }
        }
    }
}
