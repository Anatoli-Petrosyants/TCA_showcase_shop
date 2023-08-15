//
//  ProgressViewWrapper.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import SwiftUI

struct ProgressViewWrapper: View {
    @Binding var progress: Double
    
    var body: some View {
        ProgressView(value: progress)
            .background(Color.gray)
            .tint(Color.black)
            .scaleEffect(0.5, anchor: .center)
            .frame(width: 202, height: 2, alignment: .center)
    }
}
