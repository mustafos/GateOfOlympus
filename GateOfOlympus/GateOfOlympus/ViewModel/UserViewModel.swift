//
//  UserViewModel.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 20.05.2024.
//

import SwiftUI
import AVFoundation

class UserViewModel: ObservableObject {
    @AppStorage("isUserLogin") var isUserLogin: Bool = false
}
