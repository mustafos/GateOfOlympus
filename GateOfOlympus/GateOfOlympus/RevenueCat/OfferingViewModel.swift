//
//  OfferingViewModel.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 26.10.2024.
//

import Foundation
import RevenueCat

@MainActor
final class OfferingViewModel: ObservableObject {

    func start() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            let packages = offerings.current?.availablePackages ?? []
//            packageViewModels = packages.map(PackageViewModel.init(package:))
        } catch {
            print("Unable to Fetch Offerings \(error)")
        }
    }
}
