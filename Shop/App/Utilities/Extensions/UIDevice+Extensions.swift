//
//  UIDevice+Extensions.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 27.12.23.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
