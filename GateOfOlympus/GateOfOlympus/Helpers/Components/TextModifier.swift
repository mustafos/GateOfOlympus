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
            .font(.custom("Montserrat-Black", size: size))
            .foregroundStyle(color)
    }
}

struct BodyModifier: ViewModifier {
    let size: CGFloat
    let color: Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Montserrat-Regular", size: size))
            .foregroundStyle(color)
    }
}
