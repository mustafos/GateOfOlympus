//
//  ExampleView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

import SwiftUI
import StoreKit

struct ExampleView: View {
    @State private var animatingAlert: Bool = false
    @State private var isCoinStore: Bool = true
    @State private var buyButtonDisabled: Bool = false
    @State private var buyNoAdsDisabled: Bool = false
    @State private var hiddenStatus: Bool = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    @State private var showRestoreAlert = false
    @State private var showSuccessRestoreAlert = false
    
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
                        Text(buyButtonDisabled ? "Purchase Compleated" : "Buy").gradientButton()
                    }.disabled(buyButtonDisabled)
                    
                    if !buyNoAdsDisabled {
                        Button {
                            withAnimation {
                                Configurations.feedback.impactOccurred()
                                // non-consumable product
                                IAPService.instance.attemptPurchaseForItemWith(productIndex: .hideAds)
                            }
                        } label: {
                            Text("NO ADS").gradientButton()
                        }
                    }
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            // non-consumable product
                            IAPService.instance.attemptPurchaseForItemWith(productIndex: .unlimited)
                        }
                    } label: {
                        Text("Unlimited access").gradientButton()
                    }
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            // restore
                            showRestoreAlert.toggle()
                        }
                    } label: {
                        Text("Restore Purchase").gradientButton()
                    }
                    .actionSheet(isPresented: $showRestoreAlert) {
                        ActionSheet(
                            title: Text("Restore Purchases?"),
                            message: Text("Do you want to restore any in-app purchases you've previously purchased?"),
                            buttons: [
                                .default(Text("Restore")) {
                                    IAPService.instance.restorePurchases()
                                },
                                .cancel()
                            ]
                        )
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
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(Configurations.IAPServicePurchaseNotification), object: nil, queue: .main) { notification in
                self.handlePurchase(notification)
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name(Configurations.IAPServiceFailureNotification), object: nil, queue: .main) { notification in
                self.handleFailed()
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name(Configurations.IAPServiceRestoreNotification), object: nil, queue: .main) { notification in
                self.handleRestore()
            }
        }
        .onDisappear {
            // Удаление наблюдателя при уходе с экрана
            NotificationCenter.default.removeObserver(self)
            animatingAlert.toggle()
        }
        .alert("Success!", isPresented: $showSuccessRestoreAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your purchases were successfully restored.")
        }
    }
    
    // MARK: - Обработка уведомления
    func handlePurchase(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        switch productID {
        case Configurations.IAP_COIN_PACK:
            buyButtonDisabled = true
            debugPrint("Coins successfully purchased.")
        case Configurations.IAP_HEART_PACK:
            debugPrint("Hearts successfully purchased.")
        case Configurations.IAP_REMOVE_ADS:
            buyNoAdsDisabled = hiddenStatus
            debugPrint("Ads removed successfully.")
        case Configurations.IAP_UNLIMITED_ACCESS:
            debugPrint("Unlimited access granted.")
        default:
            break
        }
    }
    
    func handleFailed() {
        buyButtonDisabled = false
        debugPrint("Purchase Failed")
    }
    
    func handleRestore() {
        showSuccessRestoreAlert.toggle()
        debugPrint("Restore purchase successful.")
    }
}

// MARK: - IAPServiceDelegate
extension ExampleView: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP PRODUCTS LOADED")
    }
}

#Preview {
    ExampleView()
}
