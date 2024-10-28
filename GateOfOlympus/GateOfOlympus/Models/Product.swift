//
//  Product.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 26.10.2024.
//

import Foundation

enum Product: Int {
    case coin = 0
    case heart = 1
    case hideAds = 2
    case unlimited = 3
}

enum PurchaseStatus {
    case purchased
    case restored
    case failed
}
