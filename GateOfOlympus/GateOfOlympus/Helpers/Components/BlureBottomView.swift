//
//  BlureBottomView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 21.05.2024.
//

import SwiftUI

struct BlureBottomView: View {
    var body: some View {
        Color.accentColor
            .frame(height: 50)
            .padding(.bottom, -50)
            .blur(radius: 12)
            .opacity(0.9)
            .ignoresSafeArea()
    }
}

#Preview {
    BlureBottomView()
}
