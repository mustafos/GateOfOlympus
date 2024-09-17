//
//  RotateWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 10.10.2024.
//

//
//  RotateWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 22.05.2024.
//

import SwiftUI

struct RotateWheelView: View {
    @StateObject private var musicPlayer = AudioPlayer()
    @Binding var rotation: CGFloat
    @Binding var selectedSegment: Int
    
    let segments = ["0", "0", "1", "100", "2", "10", "3", "50", "0", "10", "4", "20"]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(segments.indices, id: \.self) { index in
                    ZStack {
                        Circle()
                            .inset(by: proxy.size.width / 4)
                            .trim(from: CGFloat(index) * segmentSize, to: CGFloat(index + 1) * segmentSize)
                            .stroke(index % 2 == 0 ? Color.wheelCoins : Color.wheelHearts, style: StrokeStyle(lineWidth: proxy.size.width / 2))
                            .rotationEffect(.radians(.pi * segmentSize))
                        label(text: segments[index], index: CGFloat(index), offset: proxy.size.width / 4)
                    }
                }
            }
        }
        .onChange(of: rotation, perform: { newValue in
            let totalSegments = CGFloat(segments.count)
            let segmentSize = 2 * .pi / totalSegments
            let currentRotation = newValue.truncatingRemainder(dividingBy: 2 * .pi)
            let index = Int(currentRotation / segmentSize)
            selectedSegment = index
        })
    }
    
    var segmentSize: CGFloat {
        1 / CGFloat(segments.count)
    }
    
    func rotation(index: CGFloat) -> CGFloat {
        (.pi * (2 * segmentSize * (CGFloat(index + 1))))
    }
    
    func label(text: String, index: CGFloat, offset: CGFloat) -> some View {
        VStack {
            Image(Int(index) % 2 == 0 ? "coin" : "love")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
            Text(text)
                .modifier(TitleModifier(size: 16, color: .white))
                .padding(.bottom, 35)
        }
        .rotationEffect(.radians(rotation(index: CGFloat(index) + Double.pi)))
        .offset(x: cos(rotation(index: index)) * offset, y: sin(rotation(index: index)) * offset)
    }
}
