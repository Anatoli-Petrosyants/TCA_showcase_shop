//
//  RemoteImagesFooterView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.03.23.
//

import SwiftUI

struct RemoteImagesFooterView: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.ultraThinMaterial)
    }
}
