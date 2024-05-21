//
//  TextModifier.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    let size: CGFloat
    let color: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Montserrat", size: size))
            .foregroundStyle(color)
    }
}

struct BodyModifier: ViewModifier {
    let size: CGFloat = 15
    let color: Color = .black
    func body(content: Content) -> some View {
        content
            .font(.custom("Montserrat-Regular", size: size))
            .foregroundStyle(color)
    }
}
