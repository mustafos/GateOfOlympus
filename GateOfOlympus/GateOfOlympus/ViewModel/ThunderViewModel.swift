//
//  ThunderViewModel.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

enum GridType { case blank, oval, drop, app, circle, row, column, bomb, gift }

struct Grid {
    var gridType: GridType
    
    var icon: String {
        switch self.gridType {
        case .blank: return ""
        case .oval: return "rubin"
        case .drop: return "crown"
        case .app: return "dimond"
        case .circle: return "heart"
        case .row: return "ring"
        case .column: return "amulet"
        case .bomb: return "trophy"
        case .gift: return "bowl"
        }
    }
}

class ThunderViewModel: ObservableObject {
    
    @AppStorage("bestScore") var bestScore = 0
    
    @Published var grids = Array(repeating: Grid(gridType: .blank), count: 30)
    @Published var score = 0
    @Published var combo = 0
    @Published var isMatch = false
    @Published var isProcessing = false
    
    @Published var gameTimeLast = 60
    @Published var isPlaying = false
    @Published var isStop = false
    
    private var startDate: Date?
    private var timer: Timer?
    
    func timerStart() {
        isStop = false
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.gameTimeLast -= 1
            if(self.gameTimeLast == 0) {
                self.timer?.invalidate()
                self.timer = nil
                if self.score > self.bestScore {
                    self.bestScore = self.score
                }
                self.isPlaying = false
                self.grids = Array(repeating: Grid(gridType: .blank), count: 30)
                self.gameTimeLast = 60
            }
        }
    }
    
    func timerStop() {
        isStop = true
        timer?.invalidate()
        timer = nil
    }
    
    func gameStart() {
        self.score = 0
        self.gameTimeLast = 60
        isPlaying = true
        withAnimation(.linear(duration: 0.4)) {
            (0..<30).forEach { index in
                grids[index].gridType = [.oval, .drop, .app, .circle].randomElement()!
                if [2, 3, 4].contains(index) {
                    while([grids[index-2], grids[index-1]].allSatisfy({ $0.gridType == grids[index].gridType })) {
                        grids[index].gridType = [.oval, .drop, .app, .circle].randomElement()!
                    }
                } else if [8, 9, 10, 11, 12].contains(index) {
                    while([grids[index - 8], grids[index - 4]].allSatisfy({ $0.gridType == grids[index].gridType })) {
                        grids[index].gridType = [.oval, .drop, .app, .circle].randomElement()!
                    }
                    // MARK: – It is Harder level
                } else if ![0, 1, 4, 5].contains(index) {
                    while(
                        [grids[index-2], grids[index-1]].allSatisfy({ $0.gridType == grids[index].gridType }) || [grids[index - 5], grids[index-2]].allSatisfy({ $0.gridType == grids[index].gridType })
                    ) {
                        grids[index].gridType = [.oval, .drop, .app, .circle].randomElement()!
                    }
                }
            }
        }
        self.timerStart()
    }
    
    func checkMatch() {
        var checkList = Array(repeating: false, count: 30)
        // check row to generate checkList
        for row in 0..<6 {
            for column in 0..<3 {
                if [.oval, .drop, .app, .circle].contains(grids[row * 5 + column].gridType) && [grids[row * 5 + column + 1], grids[row * 5 + column + 2]].allSatisfy({ $0.gridType == grids[row * 5 + column].gridType }) {
                    (row * 5 + column...row * 5 + column + 2).forEach { checkList[$0] = true }
                    isMatch = true
                }
            }
        }
        // check column to generate checkList
        for row in 0..<4 {
            for column in 0..<5 {
                if [.oval, .drop, .app, .circle].contains(grids[row * 5 + column].gridType) &&
                    [grids[row * 5 + column + 5], grids[row * 5 + column + 10]].allSatisfy({ $0.gridType == grids[row * 5 + column].gridType }) {
                    stride(from: row * 5 + column, through: row * 5 + column + 10, by: 5).forEach { checkList[$0] = true }
                    isMatch = true
                }
            }
        }
        // check column gift 6
        for column in 0..<5 {
            if stride(from: column, through: column + 25, by: 5).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[column].gridType }) {
                stride(from: column, through: column + 25, by: 5).forEach { checkList[$0] = false }
                withAnimation(.linear(duration: 0.4)) {
                    stride(from: column, through: column + 25, by: 5).forEach { grids[$0].gridType = .blank }
                    grids[column + 25].gridType = .gift
                }
                score += 6
                combo += 1
            }
        }
        // check row gift 5
        for row in 0..<6 {
            if (row * 5...row * 5 + 4).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5].gridType }) {
                (row * 5...row * 5 + 4).forEach { checkList[$0] = false }
                withAnimation(.linear(duration: 0.4)) {
                    (row * 5...row * 5 + 4).forEach { grids[$0].gridType = .blank }
                    grids[row * 5 + 2].gridType = .gift
                }
                score += 5
                combo += 1
            }
        }
        // check column gift 5
        for row in 0..<2 {
            for column in 0..<5 {
                if stride(from: row * 5 + column, through: row * 5 + column + 20, by: 5).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    stride(from: row * 5 + column, through: row * 5 + column + 20, by: 5).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        stride(from: row * 5 + column, through: row * 5 + column + 20, by: 5).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 20].gridType = .gift
                    }
                    score += 5
                    combo += 1
                }
            }
        }
        // check row gift 4
        for row in 0..<6 {
            for column in 0..<2 {
                if (row * 5 + column...row * 5 + column + 3).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    (row * 5 + column...row * 5 + column + 3).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        (row * 5 + column...row * 5 + column + 3).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 1].gridType = .gift
                    }
                    score += 4
                    combo += 1
                }
            }
        }
        // check column gift 4
        for row in 0..<3 {
            for column in 0..<5 {
                if stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 15].gridType = .gift
                    }
                    score += 4
                    combo += 1
                }
            }
        }
        // check bomb (using a 3x3 center-based approach)
        for row in 1..<5 {
            for column in 1..<4 {
                let centerIndex = row * 5 + column
                let indicesToCheck = [
                    centerIndex - 6, centerIndex - 5, centerIndex - 4,
                    centerIndex - 1, centerIndex, centerIndex + 1,
                    centerIndex + 4, centerIndex + 5, centerIndex + 6
                ]
                if indicesToCheck.allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[centerIndex].gridType }) {
                    indicesToCheck.forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        indicesToCheck.forEach { grids[$0].gridType = .blank }
                        grids[centerIndex].gridType = .bomb
                    }
                    score += 5
                    combo += 1
                }
            }
        }
        // check row 4
        for row in 0..<6 {
            for column in 0..<2 {
                if (row * 5 + column...row * 5 + column + 3).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    (row * 5 + column...row * 5 + column + 3).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        (row * 5 + column...row * 5 + column + 3).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 1].gridType = .row
                    }
                    score += 4
                    combo += 1
                }
            }
        }
        // check column 4
        for row in 0..<3 {
            for column in 0..<5 {
                if stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        stride(from: row * 5 + column, through: row * 5 + column + 15, by: 5).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 15].gridType = .column
                    }
                    score += 4
                    combo += 1
                }
            }
        }
        
        // check row 3
        for row in 0..<6 {
            for column in 0..<3 {
                if (row * 5 + column...row * 5 + column + 2).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    (row * 5 + column...row * 5 + column + 2).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        (row * 5 + column...row * 5 + column + 2).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 1].gridType = .row
                    }
                    score += 3
                    combo += 1
                }
            }
        }
        // check column 3
        for row in 0..<4 {
            for column in 0..<5 {
                if stride(from: row * 5 + column, through: row * 5 + column + 10, by: 5).allSatisfy({ checkList[$0] == true && grids[$0].gridType == grids[row * 5 + column].gridType }) {
                    stride(from: row * 5 + column, through: row * 5 + column + 10, by: 5).forEach { checkList[$0] = false }
                    withAnimation(.linear(duration: 0.4)) {
                        stride(from: row * 5 + column, through: row * 5 + column + 10, by: 5).forEach { grids[$0].gridType = .blank }
                        grids[row * 5 + column + 10].gridType = .column
                    }
                    score += 3
                    combo += 1
                }
            }
        }
        // clear
        (0...29).forEach { index in
            if checkList[index] == true {
                withAnimation(.linear(duration: 0.4)) {
                    grids[index].gridType = .blank
                }
                score += 1
            }
        }
        if isMatch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.fallDown()
            }
        } else {
            combo = 0
            if self.checkDead() {
                grids.shuffle()
                self.fallDown()
            } else {
                isProcessing = false
            }
        }
    }
    
    func fallDown() {
        while grids.contains(where: { $0.gridType == .blank }) {
            (0...29).forEach { index in
                if grids[index].gridType == .blank {
                    if (0...5).contains(index) { // Top row indices for a 6x5 grid
                        grids[index].gridType = [.oval, .drop, .app, .circle].randomElement()!
                    } else {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            grids.swapAt(index, index-6) // Move element down by one row
                        }
                    }
                }
            }
        }
        isMatch = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.checkMatch()
        }
    }
    
    func clearAll() {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids = Array(repeating: Grid(gridType: .blank), count: 30)
        }
        score += 30
        combo += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func manyBomb(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        let randomGridType: GridType = [.oval, .drop, .app, .circle].randomElement()!
        (0...29).forEach { index in
            if grids[index].gridType == randomGridType {
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[index].gridType = .bomb
                }
            }
        }
        (0...29).forEach { index in
            if grids[index].gridType == .bomb {
                self.bomb(index: index)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func manyRow(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        let randomGridType: GridType = [.oval, .drop, .app, .circle].randomElement()!
        (0...29).forEach { index in
            if grids[index].gridType == randomGridType {
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[index].gridType = .row
                }
            }
        }
        (0...29).forEach { index in
            if grids[index].gridType == .row {
                self.row(index: index)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func manyColumn(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        let randomGridType: GridType = [.oval, .drop, .app, .circle].randomElement()!
        (0...29).forEach { index in
            if grids[index].gridType == randomGridType {
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[index].gridType = .column
                }
            }
        }
        (0...29).forEach { index in
            if grids[index].gridType == .column {
                self.column(index: index)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func bigBomb(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        self.bomb(index: first)
        self.bomb(index: second)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func bigCross(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        
        if second == 0 {
            self.row(index: 0)
            self.row(index: 6)
            self.column(index: 0)
            self.column(index: 1)
        } else if second == 5 {
            self.row(index: 0)
            self.row(index: 6)
            self.column(index: 4)
            self.column(index: 5)
        } else if second == 24 {
            self.row(index: 18)
            self.row(index: 24)
            self.column(index: 0)
            self.column(index: 1)
        } else if second == 29 {
            self.row(index: 18)
            self.row(index: 24)
            self.column(index: 4)
            self.column(index: 5)
        } else if (1...4).contains(second) {
            self.row(index: 0)
            self.row(index: 6)
            self.column(index: second - 1)
            self.column(index: second)
            self.column(index: second + 1)
        } else if stride(from: 5, through: 25, by: 5).contains(second) {
            self.row(index: second - 6)
            self.row(index: second)
            self.row(index: second + 6)
            self.column(index: 0)
            self.column(index: 1)
        } else if stride(from: 10, through: 20, by: 5).contains(second) {
            self.row(index: second - 6)
            self.row(index: second)
            self.row(index: second + 6)
            self.column(index: 4)
            self.column(index: 5)
        } else if (25...28).contains(second) {
            self.row(index: 18)
            self.row(index: 24)
            self.column(index: second - 1)
            self.column(index: second)
            self.column(index: second + 1)
        } else {
            self.row(index: second - 6)
            self.row(index: second)
            self.row(index: second + 6)
            self.column(index: second - 1)
            self.column(index: second)
            self.column(index: second + 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func cross(first: Int, second: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[first].gridType = .blank
            grids[second].gridType = .blank
        }
        score += 2
        combo += 1
        self.row(index: second)
        self.column(index: second)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.fallDown()
        }
    }
    
    func gift(gridType: GridType, index: Int) {
        isMatch = true
        grids[index].gridType = .blank
        score += 1
        (0...29).forEach { idx in
            if grids[idx].gridType == gridType {
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[idx].gridType = .blank
                }
                score += 1
            }
        }
        combo += 1
    }
    
    func bomb(index: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[index].gridType = .blank
        }
        score += 1
        
        let neighbors: [Int]
        
        if index == 0 {
            neighbors = [1, 6, 7]
        } else if index == 5 {
            neighbors = [4, 11, 12]
        } else if index == 24 {
            neighbors = [18, 19, 25]
        } else if index == 29 {
            neighbors = [23, 24, 28]
        } else if (1...4).contains(index) {
            neighbors = [index - 1, index + 1, index + 5, index + 6, index + 7]
        } else if stride(from: 5, through: 25, by: 5).contains(index) {
            neighbors = [index - 6, index - 5, index + 1, index + 6, index + 7]
        } else if stride(from: 4, through: 24, by: 5).contains(index) {
            neighbors = [index - 7, index - 6, index - 1, index + 5, index + 6]
        } else if (25...28).contains(index) {
            neighbors = [index - 6, index - 5, index - 1, index + 1]
        } else {
            neighbors = [index - 7, index - 6, index - 5, index - 1, index + 1, index + 5, index + 6, index + 7]
        }
        
        neighbors.forEach { idx in
            switch grids[idx].gridType {
            case .blank:
                break
            case .row:
                self.row(index: idx)
            case .column:
                self.column(index: idx)
            case .bomb:
                self.bomb(index: idx)
            case .gift:
                self.gift(gridType: [.oval, .drop, .app, .circle].randomElement()!, index: idx)
            default:
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[idx].gridType = .blank
                }
                score += 1
            }
        }
        combo += 1
    }
    
    func row(index: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[index].gridType = .blank
        }
        score += 1
        
        let rowStart = (index / 6) * 6
        (rowStart..<(rowStart + 6)).forEach { idx in
            switch grids[idx].gridType {
            case .blank:
                break
            case .column:
                self.column(index: idx)
            case .bomb:
                self.bomb(index: idx)
            case .gift:
                self.gift(gridType: [.oval, .drop, .app, .circle].randomElement()!, index: idx)
            default:
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[idx].gridType = .blank
                }
                score += 1
            }
        }
        combo += 1
    }
    
    func column(index: Int) {
        isMatch = true
        withAnimation(.easeInOut(duration: 0.4)) {
            grids[index].gridType = .blank
        }
        score += 1
        
        (stride(from: index % 6, to: 30, by: 6)).forEach { idx in
            switch grids[idx].gridType {
            case .blank:
                break
            case .row:
                self.row(index: idx)
            case .bomb:
                self.bomb(index: idx)
            case .gift:
                self.gift(gridType: [.oval, .drop, .app, .circle].randomElement()!, index: idx)
            default:
                withAnimation(.easeInOut(duration: 0.4)) {
                    grids[idx].gridType = .blank
                }
                score += 1
            }
        }
        combo += 1
    }
    
    func checkDead() -> Bool {
        if grids.contains(where: { [.row, .column, .bomb, .gift].contains($0.gridType) }) {
            return false
        }
        var testGrids = grids
        // test row
        for index in 0..<30 { // Adjusted loop range
            if index % 6 != 5 { // Check if it's not the last column
                testGrids.swapAt(index, index + 1)
                // check row to generate checkList
                for row in 0..<5 {
                    for column in 0..<4 {
                        if [.oval, .drop, .app, .circle].contains(testGrids[row * 6 + column].gridType) &&
                            [testGrids[row * 6 + column + 1], testGrids[row * 6 + column + 2]].allSatisfy({ $0.gridType == testGrids[row * 6 + column].gridType }) {
                            return false
                        }
                    }
                }
                // check column to generate checkList
                for row in 0..<4 {
                    for column in 0..<6 {
                        if [.oval, .drop, .app, .circle].contains(testGrids[row * 6 + column].gridType) && // Adjusted calculation
                            [testGrids[row * 6 + column + 6], testGrids[row * 6 + column + 12]].allSatisfy({ $0.gridType == testGrids[row * 6 + column].gridType }) { // Adjusted calculation
                            return false
                        }
                    }
                }
                testGrids.swapAt(index, index + 1)
            }
        }
        // test column
        for index in 0..<30 { // Adjusted loop range
            if index < 24 { // Check if it's not in the last 2 rows
                testGrids.swapAt(index, index + 6)
                // check row to generate checkList
                for row in 0..<5 {
                    for column in 0..<4 {
                        if [.oval, .drop, .app, .circle].contains(testGrids[row * 6 + column].gridType) &&
                            [testGrids[row * 6 + column + 1], testGrids[row * 6 + column + 2]].allSatisfy({ $0.gridType == testGrids[row * 6 + column].gridType }) {
                            return false
                        }
                    }
                }
                // check column to generate checkList
                for row in 0..<4 {
                    for column in 0..<6 {
                        if [.oval, .drop, .app, .circle].contains(testGrids[row * 6 + column].gridType) && // Adjusted calculation
                            [testGrids[row * 6 + column + 6], testGrids[row * 6 + column + 12]].allSatisfy({ $0.gridType == testGrids[row * 6 + column].gridType }) { // Adjusted calculation
                            return false
                        }
                    }
                }
                testGrids.swapAt(index, index + 6)
            }
        }
        return true
    }
}
