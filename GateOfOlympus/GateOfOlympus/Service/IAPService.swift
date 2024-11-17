//
//  IAPService.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 26.10.2024.
//

import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPService: NSObject, ObservableObject, SKProductsRequestDelegate {
    static let instance = IAPService()
    
    var delegate: IAPServiceDelegate?
    @Published var products = [SKProduct]()
    var productIds = Set<String>()
    var productRequest = SKProductsRequest()
    
    var nonConsumablePurchaseWasMade = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIds)
    }
    
    func productIdToStringSet() {
        let ids = [Configurations.IAP_COIN_PACK, Configurations.IAP_HEART_PACK, Configurations.IAP_REMOVE_ADS, Configurations.IAP_UNLIMITED_ACCESS]
        for id in ids {
            productIds.insert(id)
        }
    }
    
    func requestProducts(forIds ids: Set<String>) {
        productRequest.cancel()
        productRequest = SKProductsRequest(productIdentifiers: ids)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count == 0 {
            requestProducts(forIds: productIds)
        } else {
            delegate?.iapProductsLoaded()
            print(products[0].localizedTitle)
        }
    }
    
    func attemptPurchaseForItemWith(productIndex: Product) {
        guard productIndex.rawValue < products.count else { return }
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                complete(transaction: transaction)
                sendNotificationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier)
                debugPrint("Purchase was successful!")
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotificationFor(status: .failed, withIdentifier: nil)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNotificationFor(status: .restored, withIdentifier: nil)
        setNonConsumablePurchase(true)
    }
    
    func complete(transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case Configurations.IAP_COIN_PACK:
            break
        case Configurations.IAP_HEART_PACK:
            break
        case Configurations.IAP_REMOVE_ADS:
            setNonConsumablePurchase(true)
            break
        case Configurations.IAP_UNLIMITED_ACCESS:
            setNonConsumablePurchase(true)
            break
        default:
            break
        }
    }
    
    func setNonConsumablePurchase(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: "nonConsumablePurchaseWasMade")
    }
    
    func sendNotificationFor(status: PurchaseStatus, withIdentifier identifier: String?) {
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(Configurations.IAPServicePurchaseNotification), object: identifier)
            break
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(Configurations.IAPServiceRestoreNotification), object: nil)
            break
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(Configurations.IAPServiceFailureNotification), object: nil)
            break
        }
    }
}
