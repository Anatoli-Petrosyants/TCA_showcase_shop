//
//  UIImage+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.03.23.
//

import UIKit

extension UIImage {
    
    func withColor(_ color: UIColor) -> UIImage {
        return self.withTintColor(color, renderingMode: .alwaysOriginal)
    }
}
