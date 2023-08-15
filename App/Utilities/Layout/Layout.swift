//
//  Layout.swift
//  Core
//
//  Created by Anatoli Petrosyants on 03/06/2021.
//

import UIKit

public final class Layout {
    private init() {}
    
    static var scaleFactor: CGFloat =  {
        let screenWidth = UIScreen.main.bounds.width
        var screenHeight = UIScreen.main.bounds.height
        
        if let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        {
            let safeArea = window.safeAreaInsets
            screenHeight -= (safeArea.top + safeArea.bottom)
        }
        let screenResolution = sqrt(pow(screenWidth, 2) + pow(screenHeight, 2))
        let designViewPortResolution = sqrt(pow(CGFloat(375.0), 2) + pow(CGFloat(734.0), 2))
        let scaleFactor = screenResolution / designViewPortResolution
        return min(scaleFactor, 1.0)
    }()
    
    /// Returns scaled number based on device size
    /// - Parameter f: Source number
    static func scaled(_ source: CGFloat) -> CGFloat {
        return source * scaleFactor
    }
}
