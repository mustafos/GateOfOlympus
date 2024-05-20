//
//  MagicWheelView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct MagicWheelView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            NavBarComponent(title: "Magic Wheel", leftIcon: "menu", rightIcon: "skip") {
                dismiss()
            } dismissRightAction: {
                dismiss()
            }

            Text("Magic Wheel")
        }
    }
}

#Preview {
    MagicWheelView()
}
