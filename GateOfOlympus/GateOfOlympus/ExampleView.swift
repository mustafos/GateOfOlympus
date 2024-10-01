//
//  ExampleView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import SwiftUI
import StoreKit

struct ExampleView: View {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        List(purchaseManager.products, id: \.productIdentifier) { product in
            Button(action: {
                purchaseManager.buyProduct(product: product)
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.localizedTitle)
                            .font(.headline)
                        Text(product.localizedDescription)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Text(priceString(for: product))
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func priceString(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "Price not available"
    }
}
