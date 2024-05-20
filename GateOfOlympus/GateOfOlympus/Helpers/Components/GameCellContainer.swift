//
//  GameCellContainer.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

struct GameCellContainer: View {
    var name: String
    var chevron: Bool
    var body: some View {
        HStack(spacing: 20) {
            Text(name)
            Spacer()
            if chevron {
                Image("arrow")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }
        }
        .textAreaConteiner()
        .foregroundColor(Color(.label))
    }
}
