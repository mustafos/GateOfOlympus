//
//  TextAreaConteiner.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI

typealias TextAreaConteiner = View

extension TextAreaConteiner {
    func textAreaConteiner() -> some View {
        return self
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(24)
    }
}
