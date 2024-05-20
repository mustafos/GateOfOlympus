//
//  ThunderBallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct ThunderBallView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            NavBarComponent(title: "God of Thunder", leftIcon: "menu", rightIcon: "skip") {
                dismiss()
            } dismissRightAction: {
                dismiss()
            }

            Text("ThunderBallView")
        }
    }
}

#Preview {
    ThunderBallView()
}
