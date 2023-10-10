//
//  BasketEmptyView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ReducerView

struct AddProductView {
    let store: StoreOf<AddProductFeature>
}

// MARK: - Views

extension AddProductView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 24) {
                HStack {
                    LottieViewRepresentable(name: "onboarding_1",
                                            loopMode: .autoReverse,
                                            play:.constant(true))
                    .frame(width: 80, height: 60)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(Localization.Basket.addProductsEmpty)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(Localization.Basket.addProductsTopPicks)
                            .font(.subheadline)
                            .foregroundColor(.black05)
                    }
                    
                    Spacer()
                }
                
                Button {
                    viewStore.send(.view(.onAddProductsButtonTap))
                } label: {
                    Text(Localization.Basket.addProductsTitle)
                        .font(.headlineBold)
                        .foregroundColor(.black)
                        .underline()
                }
            }
            .padding([.leading, .trailing, .top], 24)            
        }
    }
}
