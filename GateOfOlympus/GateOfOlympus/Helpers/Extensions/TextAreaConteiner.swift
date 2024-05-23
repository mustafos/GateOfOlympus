//
//  TextAreaConteiner.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

typealias TextAreaConteiner = View

extension TextAreaConteiner {
    func textAreaConteiner(background: Color, corner: CGFloat) -> some View {
        return self
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(background)
            .cornerRadius(corner)
            .overlay {
                if background != .white {
                    RoundedRectangle(cornerRadius: corner)
                        .stroke(LinearGradient(
                            colors: [Color.wheelHearts, Color.sea],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1)
                }
            }
    }
}
