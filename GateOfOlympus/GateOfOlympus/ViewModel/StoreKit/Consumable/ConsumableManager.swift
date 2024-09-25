//
//  ConsumableManager.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 13.10.2024.
//

// MARK: Constants
import Foundation

// Consumable
let IAP_COIN_PACK = "com.olympus.coin.pack"
let IAP_HEART_PACK = "com.olympus.heart.pack"

// Non-consumable
let IAP_REMOVE_ADS = "com.olympus.noads"
let IAP_UNLIMITED_ACCESS = "com.olympus.unlimaccess"


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
}

// MARK: Manager
struct ConsumableManager: View {
    
    var body: some View {
        Text("Hello, World!")
    }
}

// MARK: View
struct StoreView: View {
    @State private var animatingAlert: Bool = false
    @State private var isCoinStore: Bool = true
    
//    @State private var products: [SKProduct] = []
    
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
                            // consumable product
                        }
                    } label: {
                        Text("Buy").gradientButton()
                    }
                    
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
        }
    }
    
    // MARK: - IAPServiceDelegate
//        func iapProductsLoaded() {
//            self.products = IAPService.instance.products
//            print("IAP PRODUCTS LOADED")
//        }
    
//    func purchaseProduct() {
//            guard let product = products.first else { return }
//        }
}

// MARK: - IAPServiceDelegate
extension StoreView: IAPServiceDelegate {
    func iapProductsLoaded() {
//        self.products = IAPService.instance.products
                    print("IAP PRODUCTS LOADED")
    }
}

#Preview {
    StoreView()
}
