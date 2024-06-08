//
//  ParameterView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 07.06.2024.
//

import SwiftUI

struct ParameterView: View {
    @Binding var isOn: Bool
    var image: String
    var name: String
    
    var body: some View {
        Toggle(isOn: $isOn, label: {
            HStack(spacing: 16) {
                Image(image)
                Text(name)
                    .modifier(BodyModifier(size: 16, color: .white))
            }
        })
        .toggleStyle(SwitchToggleStyle(tint: .love))
        .padding(8)
        .background(Color.navigation)
        .cornerRadius(12)
        .shadow(radius: 12)
    }
}

#Preview {
    ParameterView(isOn: .constant(false), image: "music", name: "Music")
}
