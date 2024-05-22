//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    @State var rotation: CGFloat = 0.0
    @State private var showGod = false
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.accentColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    HeaderView().padding(.bottom, 54)
                    Spacer()
                    MagicWheel()
                    Image("God")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(showGod ? 1.0 : 2.0)
                        .padding(.bottom, -50)
                    
                    BlureBottomView()
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .onAppear() {
                withAnimation(.easeInOut(duration: 1.0).repeatCount(1)) {
                    showGod = true
                }
            }
        }.navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    feedback.impactOccurred()
                    dismiss()
                }
            } label: {
                Image("back")
            }
            
            Text("Magic Wheel")
                .modifier(TitleModifier(size: 18, color: .white))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            
            CoinsBalanceView(isCoins: true, score: "100")
            CoinsBalanceView(isCoins: false, score: "14")
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.navigation)
    }
    
    @ViewBuilder
    func MagicWheel() -> some View {
        ZStack {
            Image("wheelBG")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
                .overlay {
                    RotateWheelView(rotation: $rotation)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                        .rotationEffect(.radians(rotation))
                        .animation(.easeInOut(duration: 1.5), value: rotation)
                        .overlay {
                            Button {
                                let randomAmount = Double(Int.random(in: 7..<100))
                                rotation += randomAmount
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
}

//MARK: – Only custom wheel
//import SwiftUI
//
//struct MagicWheelView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var spin: Double = 0
//    @State private var stoppedAtPie: Int?
//
//    var body: some View {
//        VStack(spacing: 0) {
//            NavBarComponent(title: "Magic Wheel", leftIcon: "menu", rightIcon: "skip") {
//                dismiss()
//            } dismissRightAction: {
//                dismiss()
//            }
//
//            VStack {
//                ZStack {
//                    ForEach(0..<12, id: \.self) { index in
//                        Pie(startAngle: .degrees(Double(index) / 12 * 360), endAngle: .degrees(Double(index + 1) / 12 * 360))
//                            .fill(index % 2 == 0 ? Color.sea : Color.navigation)
//                    }
//                }.rotationEffect(.degrees(spin))
//
//                Spacer()
//
//                HStack {
//                    Button(action: {
//                        spinWheel()
//                    }) {
//                        Text("Spin").padding()
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }.padding()
//
//                if let stoppedAtPie = stoppedAtPie {
//                    Text("Stopped at pie: \(stoppedAtPie + 1)")
//                        .foregroundColor(.white)
//                        .padding()
//                }
//            }
//            Spacer()
//        }.background(Color.accentColor)
//    }
//
//    private func spinWheel() {
//        let randomRotation = Double.random(in: 360...7200) // Adjust the range as needed
//        withAnimation(.spring(response: 2, dampingFraction: 1.5)) {
//            spin += randomRotation
//        }
//
//        let pieAngle = 360 / 12.0
//        let normalizedSpin = (spin.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
//        stoppedAtPie = Int(normalizedSpin / pieAngle)
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
//#Preview {
//    MagicWheelView()
//}

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
