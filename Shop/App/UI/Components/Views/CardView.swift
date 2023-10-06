//
//  CardView.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 05.10.23.
//

import SwiftUI

struct CardView<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            content()
        }
        .background(Color.white)
        .cornerRadius(16.0)
        .shadow(color: .black01, radius: 10.0)
    }
}
