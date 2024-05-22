//
//  WishlistActionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 02.10.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - WishlistActionsView

struct WishlistActionsView {
    let store: StoreOf<WishlistActionsFeature>
}

// MARK: - Views

extension WishlistActionsView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    store.send(.view(.onRemoveTap))
                } label: {
                    Text("Remove")
                        .font(.title1)
                        .foregroundColor(.black)
                }
                
                Spacer()

                Button {
                    store.send(.view(.onAddTap))
                } label: {
                    Text("Add")
                        .font(.title1)
                        .foregroundColor(.black)
                }
            }
            
            Text("Swipe left to remove favorite and right to add a product to the basket.")
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.black05)
                .padding(.top, 8)
        }
        .padding(16)
    }
}
