//
//  ContentView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isOnboarding") var isUserLogin: Bool?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if isUserLogin == true {
            NavigationView {
                VStack(spacing: 0) {
                    
                    NavigationLink {
                        MagicWheelView().navigationBarBackButtonHidden()
                    } label: {
                        GameCellContainer(name: "Magic Wheel", chevron: true)
                    }
                    
                    NavigationLink {
                        ThunderBallView().navigationBarBackButtonHidden()
                    } label: {
                        GameCellContainer(name: "God of Thunder", chevron: true)
                    }
                    Text("Hello").gradientButton()
                    Button("Show Onboarding") {
                        isUserLogin = false
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .navigationViewStyle(.stack)
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    HomeView()
}

// MARK: Magic Wheel
//import SwiftUI
//
//struct WheelSegment: Identifiable {
//    var id = UUID()
//    var label: String
//    var color: Color
//}
//
//struct SpinWheelView: View {
//    @State private var rotation: Double = 0
//    @State private var isSpinning = false
//    @State private var selectedSegmentLabel: String?
//
//    private let segments = [
//        WheelSegment(label: "0", color: .purple),
//        WheelSegment(label: "0", color: .pink),
//        WheelSegment(label: "1", color: .orange),
//        WheelSegment(label: "100", color: .green),
//        WheelSegment(label: "2", color: .blue),
//        WheelSegment(label: "10", color: .red),
//        WheelSegment(label: "3", color: .yellow),
//        WheelSegment(label: "50", color: .gray),
//        WheelSegment(label: "0", color: .purple),
//        WheelSegment(label: "10", color: .purple),
//        WheelSegment(label: "4", color: .purple),
//        WheelSegment(label: "20", color: .purple),
//    ]
//
//    var body: some View {
//        VStack {
//            if let selectedSegmentLabel = selectedSegmentLabel {
//                Text("Selected: \(selectedSegmentLabel)")
//                    .font(.title)
//                    .padding()
//            }
//
//            ZStack {
//                ForEach(segments.indices) { index in
//                    Pie(startAngle: .degrees(Double(index) / Double(segments.count) * 360),
//                        endAngle: .degrees(Double(index + 1) / Double(segments.count) * 360))
//                        .fill(segments[index % segments.count].color)
//                        .overlay(
//                            Text(segments[index].label)
//                                .position(calculateTextPosition(for: index, in: segments.count))
//                        )
//                }
//
//                Circle()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.white)
//                    .overlay(Text("Spin").font(.title).foregroundColor(.black))
//                    .onTapGesture {
//                        spinWheel()
//                    }
//            }
//            .frame(width: 300, height: 300)
//            .rotationEffect(Angle.degrees(rotation))
//            .animation(isSpinning ? .easeOut(duration: 3) : .none)
//
//            PointerView()
//                .offset(y: -180)
//        }
//    }
//
//    private func spinWheel() {
//        guard !isSpinning else { return }
//
//        isSpinning = true
//        let newRotation = rotation + 360 * 5 + Double.random(in: 0..<360)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            let segmentAngle = 360.0 / Double(segments.count)
//            let adjustedRotation = newRotation.truncatingRemainder(dividingBy: 360)
//            let selectedSegmentIndex = Int((360 - adjustedRotation) / segmentAngle) % segments.count
//
//            selectedSegmentLabel = segments[selectedSegmentIndex].label
//            isSpinning = false
//        }
//
//        rotation = newRotation
//    }
//
//    private func calculateTextPosition(for index: Int, in totalSegments: Int) -> CGPoint {
//        let angle = (Double(index) / Double(totalSegments) + Double(index + 1) / Double(totalSegments)) * .pi
//        let radius: CGFloat = 120 // Adjust radius based on the size of your wheel
//        let x = cos(angle) * radius + radius
//        let y = sin(angle) * radius + radius
//        return CGPoint(x: x, y: y)
//    }
//}
//
//struct Pie: Shape {
//    var startAngle: Angle
//    var endAngle: Angle
//    func path(in rect: CGRect) -> Path {
//        let center = CGPoint(x: rect.midX, y: rect.midY)
//        let radius = min(rect.width, rect.height) / 2
//        let start = CGPoint(
//            x: center.x + radius * cos(CGFloat(startAngle.radians)),
//            y: center.y + radius * sin(CGFloat(startAngle.radians))
//        )
//        var path = Path()
//        path.move(to: center)
//        path.addLine(to: start)
//        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        path.addLine(to: center)
//        return path
//    }
//}
//
//struct PointerView: View {
//    var body: some View {
//        Triangle()
//            .fill(Color.yellow)
//            .frame(width: 30, height: 30)
//            .rotationEffect(Angle.degrees(180))
//            .overlay(Triangle().stroke(Color.black, lineWidth: 2))
//    }
//}
//
//struct Triangle: Shape {
//    func path(in rect: CGRect) -> Path {
//        Path { path in
//            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//            path.closeSubpath()
//        }
//    }
//}
//
//struct HomeView: View {
//    var body: some View {
//        SpinWheelView()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}


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
