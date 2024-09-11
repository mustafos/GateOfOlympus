//
//  SubscriptionManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import StoreKit
import SwiftUI

class InAppPurchaseManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    @Published var purchasedProductIDs: Set<String> = []

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        fetchProducts()
    }

    func fetchProducts() {
        let productIdentifiers: Set<String> = [
            "com.olympus.coinpack",
            "com.olympus.heartpack",
            "com.olympus.noads",
            "com.olympus.unlimitedaccess"
        ]
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }

    func buyProduct(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            // Handle user not allowed to make payments
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                let productID = transaction.payment.productIdentifier
                purchasedProductIDs.insert(productID)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // Handle failed purchase
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // Handle restored purchase
                let productID = transaction.original?.payment.productIdentifier
                if let productID = productID {
                    purchasedProductIDs.insert(productID)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
