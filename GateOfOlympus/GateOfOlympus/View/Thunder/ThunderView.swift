//
//  ThunderBallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct ThunderView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var manager = ThunderViewModel()
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ThunderHeaderView(manager: manager)
                TimerView(manager: manager, geometry: geometry)
                ThunderGridView(manager: manager)
                if manager.combo != 0 {
                    withAnimation(.linear(duration: 0.4)) {
                        Text("Combo ")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
                        +
                        Text("\(manager.combo)")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 236/255, green: 140/255, blue: 85/255))
                        +
                        Text(" !")
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 120/255, green: 111/255, blue: 102/255))
                    }
                }
                Spacer()
            }
        }
        .background(
            Image("backgroundThunder")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        
//        NavigationView {
//            ZStack {
//                Image("backgroundThunder")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                VStack(spacing: 0) {
//                    NavigationBar()
//                    Spacer()
//                    Text("ThunderBallView")
//                }
//                .navigationBarTitle("")
//                .navigationBarHidden(true)
//            }
//        }.navigationViewStyle(.stack)
    }
    
//    @ViewBuilder
//    func NavigationBar() -> some View {
//        HStack(spacing: 20) {
//            Button {
//                withAnimation {
//                    feedback.impactOccurred()
//                    dismiss()
//                }
//            } label: {
//                Image("menu")
//            }
//            
//            Spacer()
//            CoinsBalanceView(isCoins: true, score: "100")
//            CoinsBalanceView(isCoins: false, score: "14")
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 50)
//        .padding(.bottom, 10)
//        .background(Color.navigation)
//    }
}

//MARK: Candy Crush Saga
//import SwiftUI
//
//// Enum for the type of piece
//enum PieceType: String, CaseIterable {
//    case blueGem, redGem, greenGem, yellowGem, purpleGem, orangeGem
//
//    var color: Color {
//        switch self {
//        case .blueGem: return .blue
//        case .redGem: return .red
//        case .greenGem: return .green
//        case .yellowGem: return .yellow
//        case .purpleGem: return .purple
//        case .orangeGem: return .orange
//        }
//    }
//}
//
//// Model for a game piece
//struct GamePiece: Identifiable, Hashable {
//    var id = UUID()
//    var type: PieceType
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    static func == (lhs: GamePiece, rhs: GamePiece) -> Bool {
//        lhs.id == rhs.id
//    }
//}
//
//// View model for the game
//class GameViewModel: ObservableObject {
//    @Published var grid: [[GamePiece?]]
//    let rows: Int
//    let columns: Int
//
//    init(rows: Int, columns: Int) {
//        self.rows = rows
//        self.columns = columns
//        self.grid = Array(repeating: Array(repeating: nil, count: columns), count: rows)
//        fillGrid()
//    }
//
//    private func fillGrid() {
//        for row in 0..<rows {
//            for column in 0..<columns {
//                grid[row][column] = GamePiece(type: PieceType.allCases.randomElement()!)
//            }
//        }
//    }
//
//    func swapPieces(at firstIndex: (row: Int, column: Int), with secondIndex: (row: Int, column: Int)) {
//        let temp = grid[firstIndex.row][firstIndex.column]
//        grid[firstIndex.row][firstIndex.column] = grid[secondIndex.row][secondIndex.column]
//        grid[secondIndex.row][secondIndex.column] = temp
//    }
//
//    func findMatches() -> Set<GamePiece> {
//        var matchedPieces = Set<GamePiece>()
//
//        // Horizontal matches
//        for row in 0..<rows {
//            for column in 0..<columns - 2 {
//                if let piece = grid[row][column],
//                   grid[row][column + 1]?.type == piece.type,
//                   grid[row][column + 2]?.type == piece.type {
//                    matchedPieces.insert(piece)
//                    matchedPieces.insert(grid[row][column + 1]!)
//                    matchedPieces.insert(grid[row][column + 2]!)
//                }
//            }
//        }
//
//        // Vertical matches
//        for column in 0..<columns {
//            for row in 0..<rows - 2 {
//                if let piece = grid[row][column],
//                   grid[row + 1][column]?.type == piece.type,
//                   grid[row + 2][column]?.type == piece.type {
//                    matchedPieces.insert(piece)
//                    matchedPieces.insert(grid[row + 1][column]!)
//                    matchedPieces.insert(grid[row + 2][column]!)
//                }
//            }
//        }
//
//        return matchedPieces
//    }
//
//    func removeMatches(matches: Set<GamePiece>) {
//        for row in 0..<rows {
//            for column in 0..<columns {
//                if let piece = grid[row][column], matches.contains(piece) {
//                    grid[row][column] = nil
//                }
//            }
//        }
//    }
//
//    func fillEmptySpaces() {
//        for column in 0..<columns {
//            for row in (0..<rows).reversed() {
//                if grid[row][column] == nil {
//                    // Move pieces down
//                    for rowAbove in (0..<row).reversed() {
//                        if let piece = grid[rowAbove][column] {
//                            grid[row][column] = piece
//                            grid[rowAbove][column] = nil
//                            break
//                        }
//                    }
//                }
//            }
//        }
//
//        // Fill new pieces
//        for row in 0..<rows {
//            for column in 0..<columns {
//                if grid[row][column] == nil {
//                    grid[row][column] = GamePiece(type: PieceType.allCases.randomElement()!)
//                }
//            }
//        }
//    }
//}
//
//struct HomeView: View {
//    @StateObject var viewModel = GameViewModel(rows: 8, columns: 8)
//    @State private var selectedPiece: (row: Int, column: Int)?
//
//    var body: some View {
//        VStack {
//            if let selectedPiece = selectedPiece {
//                Text("Selected: (\(selectedPiece.row), \(selectedPiece.column))")
//                    .font(.title)
//                    .padding()
//            }
//
//            ForEach(0..<viewModel.rows, id: \.self) { row in
//                HStack {
//                    ForEach(0..<viewModel.columns, id: \.self) { column in
//                        if let piece = viewModel.grid[row][column] {
//                            Rectangle()
//                                .fill(piece.type.color)
//                                .frame(width: 40, height: 40)
//                                .onTapGesture {
//                                    handlePieceTap(row: row, column: column)
//                                }
//                                .border(Color.black, width: selectedPiece?.row == row && selectedPiece?.column == column ? 3 : 0)
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//
//    private func handlePieceTap(row: Int, column: Int) {
//        if let selected = selectedPiece {
//            if isAdjacent(first: selected, second: (row, column)) {
//                viewModel.swapPieces(at: selected, with: (row, column))
//
//                let matches = viewModel.findMatches()
//                if matches.isEmpty {
//                    // No match, swap back
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        viewModel.swapPieces(at: (row, column), with: selected)
//                    }
//                } else {
//                    // Match found, update grid
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        withAnimation {
//                            viewModel.removeMatches(matches: matches)
//                            viewModel.fillEmptySpaces()
//                        }
//                    }
//                }
//            }
//            selectedPiece = nil
//        } else {
//            selectedPiece = (row, column)
//        }
//    }
//
//    private func isAdjacent(first: (row: Int, column: Int), second: (row: Int, column: Int)) -> Bool {
//        let dRow = abs(first.row - second.row)
//        let dColumn = abs(first.column - second.column)
//        return (dRow == 1 && dColumn == 0) || (dRow == 0 && dColumn == 1)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
