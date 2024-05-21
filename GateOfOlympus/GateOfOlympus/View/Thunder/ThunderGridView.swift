//
//  ThunderGridView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct ThunderGridView: View {
    
    @ObservedObject var manager: ThunderViewModel
    
    @State private var startDetectDrag = false
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 7), spacing: 4) {
            ForEach(0..<63) { index in
                GeometryReader { geo in
                    Rectangle()
                        .frame(width: nil, height: geo.size.width)
                        .foregroundColor(Color(red: 240/255, green: 224/255, blue: 213/255))
                        .cornerRadius(8)
                        .overlay {
                            if manager.grids[index].gridType != .blank && !manager.isStop {
                                Image(manager.grids[index].icon)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(color: Color(red: 187/255, green: 174/255, blue: 161/255), radius: 2)
                                    .padding(8)
                                    .gesture(dragGesture(index: index))
                            }
                        }
                }
                .aspectRatio(contentMode: .fit)
            }
        }
        .padding(12)
        .background(Color(red: 187/255, green: 174/255, blue: 161/255))
        .cornerRadius(5)
        .overlay {
            if !manager.isPlaying {
                Button {
                    manager.gameStart()
                } label: {
                    Text("Game Start")
                        .bold()
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 236/255, green: 140/255, blue: 85/255))
                        .cornerRadius(5)
                }
            }
            if manager.isStop {
                VStack(spacing: 15) {
                    Button {
                        manager.timerStart()
                    } label: {
                        (Text(Image(systemName: "arrowtriangle.right.circle")) + Text("  Continue"))
                            .bold()
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 236/255, green: 140/255, blue: 85/255))
                            .cornerRadius(5)
                    }
                    Button {
                        manager.gameStart()
                    } label: {
                        (Text(Image(systemName: "arrow.counterclockwise.circle")) + Text("  Restart"))
                            .bold()
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 236/255, green: 140/255, blue: 85/255))
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
    
    func dragGesture(index: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                if startDetectDrag && !manager.isProcessing && manager.isPlaying && !manager.isStop {
                    if value.translation.width > 5 { // swipe right
                        if !stride(from: 6, through: 62, by: 7).contains(index) {
                            manager.isMatch = false
                            manager.isProcessing = true
                            withAnimation(.linear(duration: 0.4)) {
                                manager.grids.swapAt(index, index+1)
                            }
                            let left = manager.grids[index].gridType, right = manager.grids[index+1].gridType
                            if [left, right].allSatisfy({ $0 == .gift }) {
                                manager.clearAll()
                            } else if left == .gift && right == .bomb || left == .bomb && right == .gift {
                                manager.manyBomb(first: index, second: index+1)
                            } else if left == .gift && right == .row || left == .row && right == .gift {
                                manager.manyRow(first: index, second: index+1)
                            } else if left == .gift && right == .column || left == .column && right == .gift {
                                manager.manyColumn(first: index, second: index+1)
                            } else if [left, right].allSatisfy({ $0 == .bomb }) {
                                manager.bigBomb(first: index, second: index+1)
                            } else if [.row, .column].contains(left) && right == .bomb || left == .bomb && [.row, .column].contains(right) {
                                manager.bigCross(first: index, second: index+1)
                            } else if [.row, .column].contains(left) && [.row, .column].contains(right) {
                                manager.cross(first: index, second: index+1)
                            } else if left == .gift {
                                manager.gift(gridType: right, index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .gift {
                                manager.gift(gridType: left, index: index+1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .bomb {
                                manager.bomb(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .bomb {
                                manager.bomb(index: index+1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .row {
                                manager.row(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .row {
                                manager.row(index: index+1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .column {
                                manager.column(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .column {
                                manager.column(index: index+1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else {
                                manager.checkMatch()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !manager.isMatch {
                                    withAnimation(.linear(duration: 0.4)) {
                                        manager.grids.swapAt(index, index+1)
                                    }
                                }
                            }
                        }
                        startDetectDrag = false
                    } else if value.translation.width < -5 { // swipe left
                        if !stride(from: 0, through: 56, by: 7).contains(index) {
                            manager.isMatch = false
                            manager.isProcessing = true
                            withAnimation(.easeInOut(duration: 0.4)) {
                                manager.grids.swapAt(index, index-1)
                            }
                            let left = manager.grids[index-1].gridType, right = manager.grids[index].gridType
                            if [left, right].allSatisfy({ $0 == .gift }) {
                                manager.clearAll()
                            } else if left == .gift && right == .bomb || left == .bomb && right == .gift {
                                manager.manyBomb(first: index, second: index-1)
                            } else if left == .gift && right == .row || left == .row && right == .gift {
                                manager.manyRow(first: index, second: index-1)
                            } else if left == .gift && right == .column || left == .column && right == .gift {
                                manager.manyColumn(first: index, second: index-1)
                            } else if [left, right].allSatisfy({ $0 == .bomb }) {
                                manager.bigBomb(first: index, second: index-1)
                            } else if [.row, .column].contains(left) && right == .bomb || left == .bomb && [.row, .column].contains(right) {
                                manager.bigCross(first: index, second: index-1)
                            } else if [.row, .column].contains(left) && [.row, .column].contains(right) {
                                manager.cross(first: index, second: index-1)
                            } else if left == .gift {
                                manager.gift(gridType: right, index: index-1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .gift {
                                manager.gift(gridType: left, index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .bomb {
                                manager.bomb(index: index-1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .bomb {
                                manager.bomb(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .row {
                                manager.row(index: index-1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .row {
                                manager.row(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if left == .column {
                                manager.column(index: index-1)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if right == .column {
                                manager.column(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else {
                                manager.checkMatch()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !manager.isMatch {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        manager.grids.swapAt(index, index-1)
                                    }
                                }
                            }
                        }
                        startDetectDrag = false
                    } else if value.translation.height < -5 { // swipe up
                        if (7...62).contains(index) {
                            manager.isMatch = false
                            manager.isProcessing = true
                            withAnimation(.easeInOut(duration: 0.4)) {
                                manager.grids.swapAt(index, index-7)
                            }
                            let down = manager.grids[index].gridType, up = manager.grids[index-7].gridType
                            if [down, up].allSatisfy({ $0 == .gift }) {
                                manager.clearAll()
                            } else if down == .gift && up == .bomb || down == .bomb && up == .gift {
                                manager.manyBomb(first: index, second: index-7)
                            } else if down == .gift && up == .row || down == .row && up == .gift {
                                manager.manyRow(first: index, second: index-7)
                            } else if down == .gift && up == .column || down == .column && up == .gift {
                                manager.manyColumn(first: index, second: index-7)
                            } else if [down, up].allSatisfy({ $0 == .bomb }) {
                                manager.bigBomb(first: index, second: index-7)
                            } else if [.row, .column].contains(down) && up == .bomb || down == .bomb && [.row, .column].contains(up) {
                                manager.bigCross(first: index, second: index-7)
                            } else if [.row, .column].contains(down) && [.row, .column].contains(up) {
                                manager.cross(first: index, second: index-7)
                            } else if up == .gift {
                                manager.gift(gridType: down, index: index-7)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if down == .gift {
                                manager.gift(gridType: up, index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if down == .bomb {
                                manager.bomb(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if up == .bomb {
                                manager.bomb(index: index-7)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if down == .row {
                                manager.row(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if up == .row {
                                manager.row(index: index-7)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if down == .column {
                                manager.column(index: index)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else if up == .column {
                                manager.column(index: index-7)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    manager.fallDown()
                                }
                            } else {
                                manager.checkMatch()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !manager.isMatch {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        manager.grids.swapAt(index, index-7)
                                    }
                                }
                            }
                        }
                        startDetectDrag = false
                    } else if value.translation.height > 5 { // swipe down
                        if (0...55).contains(index) {
                            manager.isMatch = false
                            manager.isProcessing = true
                            withAnimation(.easeInOut(duration: 0.4)) {
                                manager.grids.swapAt(index, index+7)
                            }
                            let down = manager.grids[index+7].gridType, up = manager.grids[index].gridType
                            if [down, up].allSatisfy({ $0 == .gift }) {
                                manager.clearAll()
                            } else if down == .gift && up == .bomb || down == .bomb && up == .gift {
                                manager.manyBomb(first: index, second: index+7)
                            } else if down == .gift && up == .row || down == .row && up == .gift {
                                manager.manyRow(first: index, second: index+7)
                            } else if down == .gift && up == .column || down == .column && up == .gift {
                                manager.manyColumn(first: index, second: index+7)
                            } else if [down, up].allSatisfy({ $0 == .bomb }) {
                                manager.bigBomb(first: index, second: index+7)
                            } else if [.row, .column].contains(down) && up == .bomb || down == .bomb && [.row, .column].contains(up) {
                                manager.bigCross(first: index, second: index+7)
                            } else if [.row, .column].contains(down) && [.row, .column].contains(up) {
                                manager.cross(first: index, second: index+7)
                            } else if up == .gift {
                                manager.gift(gridType: down, index: index)
                                manager.fallDown()
                            } else if down == .gift {
                                manager.gift(gridType: up, index: index+7)
                                manager.fallDown()
                            } else if down == .bomb {
                                manager.bomb(index: index+7)
                                manager.fallDown()
                            } else if up == .bomb {
                                manager.bomb(index: index)
                                manager.fallDown()
                            } else if down == .row {
                                manager.row(index: index+7)
                                manager.fallDown()
                            } else if up == .row {
                                manager.row(index: index)
                                manager.fallDown()
                            } else if down == .column {
                                manager.column(index: index+7)
                                manager.fallDown()
                            } else if up == .column {
                                manager.column(index: index)
                                manager.fallDown()
                            } else {
                                manager.checkMatch()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if !manager.isMatch {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        manager.grids.swapAt(index, index+7)
                                    }
                                }
                            }
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
}
