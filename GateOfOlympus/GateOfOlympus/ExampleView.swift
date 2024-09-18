//
//  ExampleView.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 11.09.2024.
//

//import SwiftUI
//import StoreKit
//
//struct ExampleView: View {
//    @StateObject private var purchaseManager = InAppPurchaseManager()
//    
//    var body: some View {
//        List(purchaseManager.products, id: \.productIdentifier) { product in
//            Button(action: {
//                purchaseManager.buyProduct(product: product)
//            }) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(product.localizedTitle)
//                            .font(.headline)
//                        Text(product.localizedDescription)
//                            .font(.subheadline)
//                    }
//                    Spacer()
//                    Text(priceString(for: product))
//                        .font(.headline)
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//    }
//    
//    private func priceString(for product: SKProduct) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = product.priceLocale
//        return formatter.string(from: product.price) ?? "Price not available"
//    }
//}

//TODO: – RULETTE
import SwiftUI

enum TypeRevard: String {
    case coins = "WheelCoinsColor"
    case hearts = "WheelHeartsColor"
    case empty
}

struct Sector: Equatable {
    let point: Int
    let type: TypeRevard
}

struct ExampleView2: View {
    @State private var isAnimating = false
    @State private var spinDegrees = 0.0
    @State private var rand = 0.0
    @State private var newAngle = 0.0
    @State private var rotation: CGFloat = 0.0
    @State private var selectedSegment: Int = 0
    
    let halfSector = 360.0 / 11.0 / 2.0
    let sectors: [Sector] = [/*Sector(point: 0, type: .coins),*/
                             Sector(point: 0, type: .hearts),
                             Sector(point: 1, type: .coins),
                             Sector(point: 100, type: .hearts),
                             Sector(point: 2, type: .coins),
                             Sector(point: 10, type: .hearts),
                             Sector(point: 3, type: .coins),
                             Sector(point: 50, type: .hearts),
                             Sector(point: 0, type: .coins),
                             Sector(point: 10, type: .hearts),
                             Sector(point: 4, type: .coins),
                             Sector(point: 20, type: .hearts)]
    
    var spinAnimation: Animation {
        Animation.easeOut(duration: 3.0)
            .repeatCount(1, autoreverses: false)
    }
    
    func getAngle(angle: Double) -> Double {
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        return deg
    }
    
//    func sectorFromAngle(angle: Double) -> String {
//        let sector = sectors[selectedSegment]
//        return "Sector\n\(sector.point) \(sector.type.rawValue)"
//    }
    
    func sectorFromAngle(angle: Double) -> String {
        var i = 0
        var sector: Sector = Sector(point: -1, type: .empty)
        
        while sector == Sector(point: -1, type: .empty) && i < sectors.count {
            let start: Double = halfSector * Double((i*2 + 1)) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if(angle >= start && angle < end) {
                sector = sectors[i]
            }
            i+=1
        }
        return "Sector\n\(sector.point) \(sector.type.rawValue)"
    }
    
    var body: some View {
        VStack {
            Text(self.isAnimating ? "Spinning\n..." : sectorFromAngle(angle : newAngle))
                .multilineTextAlignment(.center)
            Image("drop")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25, alignment: .center)
            
            RotateWheelView(rotation: $rotation, selectedSegment: $selectedSegment)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 32)
                .rotationEffect(Angle(degrees: spinDegrees))
                .animation(spinAnimation, value: rotation)
                .overlay {
                    Button {
                        isAnimating = true
                        rand = Double.random(in: 1...360)
                        spinDegrees += 720.0 + rand
                        newAngle = getAngle(angle: spinDegrees)
                        rotation = CGFloat(spinDegrees * .pi / 180)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                            isAnimating = false
                        }
                    } label: {
                        ZStack {
                            Image("spin")
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 50, idealWidth: 100, maxWidth: 120)
                                .padding(Device.iPad ? 150 : 100)
                            Text("Spin").modifier(TitleModifier(size: 15, color: .white))
                        }
                    }.disabled(isAnimating)
                }
            
            //            Button("SPIN") {
            //                isAnimating = true
            //                rand = Double.random(in: 1...360)
            //                spinDegrees += 720.0 + rand
            //                newAngle = getAngle(angle: spinDegrees)
            //                rotation = CGFloat(spinDegrees * .pi / 180) // Bind rotation to the new angle in radians
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
            //                    isAnimating = false
            //                }
            //            }
            //            .padding(40)
            //            .disabled(isAnimating == true)
        }
    }
}
