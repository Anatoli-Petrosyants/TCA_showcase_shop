//
//  ProductsAccountView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductAccountView

struct ProductsAccountView {
    let store: StoreOf<ProductsAccountFeature>
}

// MARK: - Views

extension ProductsAccountView: View {
    
    var body: some View {
        content
            .onLoad { self.store.send(.view(.onViewLoad)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .background(
                            Circle()
                                .foregroundColor(Color.black)
                        )
                    
                    Text(viewStore.name.prefix(1).capitalized)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 35, alignment: .center)
                
                HStack(spacing: 0) {
                    Text("Hello, ")
                        .font(.title2)
                    
                    Text(viewStore.name)
                        .font(.title2Bold)
                }
                
                Text(viewStore.countryCode.countryFlag())
                
                Spacer()
            }
            .onTapGesture {
                viewStore.send(.view(.onTap))
            }
        }
    }
}
