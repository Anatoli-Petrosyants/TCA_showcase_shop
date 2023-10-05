//
//  LinkButtonStyle.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

struct LinkButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .underline()
            .font(.subheadline)
            .foregroundColor(.black)
    }
}

extension ButtonStyle where Self == LinkButtonStyle {
    static var linkButton: LinkButtonStyle { .init() }
}
