//
//  GradientButton.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

typealias GradientButton = View
extension GradientButton {
    func gradientButton() -> some View {
        self
            .frame(height: 38)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.love, Color.heart]), startPoint: .leading, endPoint: .trailing))
            .modifier(TitleModifier(size: 14, color: .white))
            .cornerRadius(10)
            .shadow(radius: 5, x: 0, y: 2)
    }
}
