//
//  PaywallView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 30.10.2024.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @ObservedObject var iapService = IAPService.instance
    @EnvironmentObject private var musicPlayer: AudioPlayer
    @EnvironmentObject private var thunderManager: ThunderViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent.ignoresSafeArea()
            Image("God")
                .resizable()
                .scaledToFit()
                .padding(.bottom, -50)
            
            BlureBottomView()
            
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            dismiss()
                        }
                    } label: {
                        Image("back")
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("Store")
                        .modifier(TitleModifier(size: 16, color: .white))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        withAnimation {
                            Configurations.feedback.impactOccurred()
                            musicPlayer.playSound(sound: "drop", type: "mp3", isSoundOn: musicPlayer.isSoundOn)
                            iapService.restorePurchases()
                        }
                    } label: {
                        Image("restore")
                    }
                }
                .padding(.top, 40)
                .padding(20)
                .background(Color.navigation)
                .padding(.bottom, 24)
                .ignoresSafeArea()
                
                Text("Step into the Winner’s Circle!")
                    .modifier(TitleModifier(size: 18, color: .white))
                    .padding()
                
                // Loop through the available products to display title and price
                ForEach(iapService.products, id: \.self) { product in
                    Button {
                        if let index = iapService.products.firstIndex(of: product) {
                            iapService.attemptPurchaseForItemWith(productIndex: Product(rawValue: index)!)
                        }
                    } label: {
                        productCellView(title: product.localizedTitle, description: product.localizedDescription, price: product.localizedPrice(), image: product.localizedImage()
                        )
                    }
                    .buttonStyle(.plain)
//                    .disabled(subscriptionsManager.isLoading)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
            }
        }
        .onAppear {
            iapService.loadProducts()
        }
    }
    
    @ViewBuilder
    func productCellView(title: String, description: String?, price: String, image: String) -> some View {
        HStack(spacing: 16) {
            Image(image)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .modifier(BodyModifier(size: 16, color: .white))
                if description != nil {
                    Text(description!)
                        .modifier(BodyModifier(size: 12, color: .white))
                }
            }
            Spacer()
            Text(price)
                .modifier(BodyModifier(size: 16, color: .white))
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(
                    Capsule()
                        .foregroundColor(Color.black.opacity(0.7))
                )
        }
        .padding(12)
        .background(Color.navigation)
        .cornerRadius(12)
        .shadow(radius: 12)
    }
}

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }
    
    func localizedImage() -> String {
            switch productIdentifier {
            case "com.olympus.coin.pack":
                return "paycoin"
            case "com.olympus.heart.pack":
                return "heartpay"
            case "com.olympus.noads":
                return "ads"
            case "com.olympus.unlimaccess":
                return "unlim"
            default:
                return "default_image"
            }
        }
}
