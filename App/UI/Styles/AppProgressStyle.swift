//
//  AppProgressStyle.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import SwiftUI

struct AppProgressStyle: ProgressViewStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        ProgressView(configuration)
            .scaleEffect(1.5)
            .tint(.black)
    }
}

extension ProgressViewStyle where Self == AppProgressStyle {
    static var main: AppProgressStyle { .init() }
}

