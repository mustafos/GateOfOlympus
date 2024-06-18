//
//  Ext+Device.swift
//  GateOfOlympus
//
//  Created by Mustafa Bekirov on 18.06.2024.
//

import UIKit

enum Device {
    static var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    static var iPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
}
