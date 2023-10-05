//
//  AnyTransition+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import SwiftUI

extension AnyTransition {
    static var delayAndFade: AnyTransition {
        return AnyTransition.identity
              .combined(with: .opacity)
              .animation(.default.delay(0.1))
    }
}
