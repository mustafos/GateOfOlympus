//
//  PackageViewModel.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 26.10.2024.
//

import RevenueCat

struct PackageViewModel: Identifiable {
    var id: String {
        package.identifier
    }

    let package: Package
    
    var price: String {
        package.storeProduct.localizedPriceString
    }
    
    var title: String? {
        guard let subscriptionPeriod = package.storeProduct.subscriptionPeriod else { return nil }

        switch subscriptionPeriod.unit {
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        default:
            return nil
        }
    }
    
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
