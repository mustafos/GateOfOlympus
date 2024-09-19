//
//  PurchaseManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 18.09.2024.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import StoreKit

class PurchaseManager: NSObject {
    static let instance = PurchaseManager()
    
    let IAP_COIN_PACK = "com.olympus.coinpack"
    let IAP_HEART_PACK = "com.olympus.heartpack"
    let IAP_REMOVE_ADS = "com.olympus.noads"
    
    let IAP_UNLIMITED_ACCESS = "com.olympus.unlimitedaccess"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler?
    
    func fetchProducts() {
        let productIds = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseRemoveAds(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let removeAdsProduct = products[0]
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func restorePurchases(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() {
            transactionComplete = onComplete
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            onComplete(false)
        }
    }
}

// MARK: – Request Delegate
extension PurchaseManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }
}

// MARK: – Transaction Observer
extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    transactionComplete?(true)
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(false)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                }
                transactionComplete?(true)
                break
            default:
                transactionComplete?(false)
                break
            }
        }
    }
}

import SwiftUI
import StoreKit

struct MainView: View {
    @State private var isPremium: Bool = UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS)
    var body: some View {
        VStack {
            if !isPremium {
                HStack {
                    Spacer()
                    
                    Button {
                        PurchaseManager.instance.restorePurchases { success in
                            isPremium = UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS)
                        }
                    } label: {
                        Text("Restore")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .padding(8)
                            .background(.red)
                            .clipShape(Capsule())
                    }
                }.padding()
                
                BannerView()
                
                Spacer()
                
                Button {
                    PurchaseManager.instance.purchaseRemoveAds { success in
                        isPremium = UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS)
                    }
                } label: {
                    Text("REMOVE ADS")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding(8)
                        .background(.green)
                        .clipShape(Capsule())
                    
                }
            } else {
                Text("You're premium user")
            }
        }
        .padding()
        .onChange(of: isPremium) { newValue in
            isPremium = newValue
        }
    }
    
    private func priceString(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "Price not available"
    }
}
