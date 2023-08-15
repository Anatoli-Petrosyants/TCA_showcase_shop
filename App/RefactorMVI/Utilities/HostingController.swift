//
//  HostingController.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.03.23.
//

import SwiftUI

public class HostingController<Content>: UIHostingController<Content> where Content: View {

    public var statusBarStyle: UIStatusBarStyle {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    public init(rootView: Content, statusBarStyle: UIStatusBarStyle = .default) {
        self.statusBarStyle = statusBarStyle
        super.init(rootView: rootView)
    }

    @MainActor required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
