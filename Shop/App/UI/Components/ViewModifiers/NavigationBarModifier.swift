//
//  NavigationBarModifier.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    private static var backgroundColor = UIColor(named: "white")
    private static var foregroundColor = UIColor(named: "black")

    private static var defaultBarAppearance: UINavigationBarAppearance = {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: foregroundColor!]
        appearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor!]
        appearance.shadowImage = UIImage()
        let backButtonImage = UIImage(systemName: "chevron.left")
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance
        
        return appearance
    }()
    
    init(appearance: UINavigationBarAppearance = NavigationBarModifier.defaultBarAppearance) {
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UIBarButtonItem.appearance().tintColor = NavigationBarModifier.foregroundColor
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
        }
    }
}

extension View {

    func defaultNavigationBar() -> some View {
        self.modifier(NavigationBarModifier())
    }
}
