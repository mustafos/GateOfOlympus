//
//  BadgetPosition.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 24.05.2024.
//

import SwiftUI

typealias BadgetPosition = View

extension BadgetPosition {
    func badge<Badge:View>(@ViewBuilder contents: () -> Badge) -> some View {
        self.overlay(alignment: .bottomTrailing) {
            contents()
                .frame(width: 24, height: 24)
                .background {
                    RoundedRectangle(cornerRadius: 8).fill(Color.heart)
                }
                .offset(x: 12, y: 12)
        }
    }
}
