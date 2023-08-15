//
//  Layout+Extension.swift
//  BestLook
//
//  Created by Anatoli Petrosyants on 19.04.23.
//

import UIKit

extension CGSize {
    func scaled(with factor: CGFloat = Layout.scaleFactor) -> CGSize {
        return CGSize(width: width * factor, height: height * factor)
    }
}

extension UIEdgeInsets {
    func scaled(with factor: CGFloat = Layout.scaleFactor) -> UIEdgeInsets {
        let top = Layout.scaled(self.top)
        let left = Layout.scaled(self.left)
        let right = Layout.scaled(self.right)
        let bottom = Layout.scaled(self.bottom)
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}

extension CGFloat {
    func scaled(with factor: CGFloat = Layout.scaleFactor) -> CGFloat {
        return Layout.scaled(self)
    }
}

extension Double {
    func scaled(with factor: CGFloat = Layout.scaleFactor) -> Double {
        return Layout.scaled(self)
    }
}

extension UIEdgeInsets {
    func scaled(scaleFactor: CGFloat = Layout.scaleFactor) -> UIEdgeInsets {
        let top = Layout.scaled(self.top)
        let left = Layout.scaled(self.left)
        let right = Layout.scaled(self.right)
        let bottom = Layout.scaled(self.bottom)
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
