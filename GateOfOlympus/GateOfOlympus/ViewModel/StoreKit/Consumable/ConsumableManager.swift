//
//  ConsumableManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 13.10.2024.
//

// MARK: Product
import Foundation

enum Product: Int {
    case coin = 0
    case heart = 1
    case hideAds = 2
    case unlimited = 3
}

// MARK: Purchase Status
import Foundation

enum PurchaseStatus {
    case purchased
    case restored
    case failed
}

// MARK: Constants
import Foundation

// MARK: – IAP Identifiers
// Consumable
let IAP_COIN_PACK = "com.olympus.coin.pack"
let IAP_HEART_PACK = "com.olympus.heart.pack"

// Non-consumable
let IAP_REMOVE_ADS = "com.olympus.noads"
let IAP_UNLIMITED_ACCESS = "com.olympus.unlimaccess"

// MARK: – Notification Identifier
let IAPServicePurchaseNotification = "IAPServicePurchaseNotification"
let IAPServiceRestoreNotification = "IAPServiceRestoreNotification"
let IAPServiceFailureNotification = "IAPServiceFailureNotification"


// MARK: Service with Protocol
import SwiftUI
import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPService: NSObject, SKProductsRequestDelegate {
    static let instance = IAPService()
    
    var delegate: IAPServiceDelegate?
    
    var products = [SKProduct]()
    var productIds = Set<String>()
    var productRequest = SKProductsRequest()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func loadProducts() {
        productIdToStringSet()
        requestProducts(forIds: productIds)
    }
    
    func productIdToStringSet() {
        productIds.insert(IAP_COIN_PACK)
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
        let product = products[productIndex.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotificationFor(status: .purchased, withIdentifier: transaction.payment.productIdentifier)
                debugPrint("Purchase was successful!")
                break
            case .restored:
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
    
    func sendNotificationFor(status: PurchaseStatus, withIdentifier identifier: String?) {
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
            break
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
            break
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
            break
        }
    }
}

// MARK: View
struct StoreView: View {
    @State private var animatingAlert: Bool = false
    @State private var isCoinStore: Bool = true
    @State private var buyButtonDisabled: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Button {
                    withAnimation {
                        Configurations.feedback.impactOccurred()
                        animatingAlert.toggle()
                        isCoinStore = true
                    }
                } label: {
                    Text("Coins Store").gradientButton()
                }
                
                Button {
                    withAnimation {
                        Configurations.feedback.impactOccurred()
                        animatingAlert.toggle()
                        isCoinStore = false
                    }
                } label: {
                    Text("Hearts Store").gradientButton()
                }
            }.padding()
            
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    Image(isCoinStore ? "coin" : "love")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 74)
                    
                    Text("Extra \(isCoinStore ? "Coins" : "Hearts")")
                        .modifier(TitleModifier(size: 18, color: .white))
                    
                    Text(isCoinStore
                         ? "You can buy an additional 100 coins"
                         : "You can purchase 5 extra hearts")
                    .modifier(BodyModifier(size: 14, color: .white))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "dollarsign")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        Text("2.99  =")
                        Image(isCoinStore ? "coin" : "love")
                            .resizable()
                            .scaledToFit()
                        Text("100")
                    }
                    .frame(height: 20)
                    .modifier(TitleModifier(size: 14, color: .white))
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            IAPService.instance.attemptPurchaseForItemWith(productIndex: isCoinStore ? .coin : .heart)
                        }
                    } label: {
                        Text(buyButtonDisabled ? "Yes" : "Buy").gradientButton()
                    }.disabled(buyButtonDisabled)
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            // non-consumable product
                        }
                    } label: {
                        Text("Unlimited access").gradientButton()
                    }
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            // restore
                        }
                    } label: {
                        Text("Restore Purchase").gradientButton()
                    }
                }
                .padding()
                .overlay(Button {
                    withAnimation {
                        Configurations.feedback.impactOccurred()
                        animatingAlert.toggle()
                    }
                } label: {
                    Image("cancel")
                }, alignment: .topTrailing)
            }
            .textAreaConteiner(background: .accent, corner: 30)
            .padding(.horizontal, 70)
            .opacity($animatingAlert.wrappedValue ? 1 : 0)
            .offset(y: $animatingAlert.wrappedValue ? 0 : -100)
        }
        .onAppear {
            IAPService.instance.delegate = self
            IAPService.instance.loadProducts()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(IAPServicePurchaseNotification), object: nil, queue: .main) { notification in
                self.handlePurchase(notification)
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name(IAPServiceFailureNotification), object: nil, queue: .main) { notification in
                self.handleFailed()
            }
        }
        .onDisappear {
            // Удаление наблюдателя при уходе с экрана
            NotificationCenter.default.removeObserver(self)
            animatingAlert.toggle()
        }
    }
    
    // MARK: - Обработка уведомления
    func handlePurchase(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        switch productID {
        case IAP_COIN_PACK:
            buyButtonDisabled = true
            debugPrint("Coins successfully purchased.")
        case IAP_HEART_PACK:
            debugPrint("Hearts successfully purchased.")
        case IAP_REMOVE_ADS:
            debugPrint("Ads removed successfully.")
        case IAP_UNLIMITED_ACCESS:
            debugPrint("Unlimited access granted.")
        default:
            break
        }
    }
    
    func handleFailed() {
        buyButtonDisabled = false
        debugPrint("Purchase Failed")
    }
}

// MARK: - IAPServiceDelegate
extension StoreView: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP PRODUCTS LOADED")
    }
}

#Preview {
    StoreView()
}
