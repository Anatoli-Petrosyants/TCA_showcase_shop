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
    let store: StoreOf<AddProductReducer>
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
                    LottieViewRepresentable(name: "basket",
                                            loopMode: .autoReverse,
                                            play:.constant(true))
                    .frame(width: 80, height: 60)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Showcase basket is empty")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Please add product or choose from top picks")
                            .font(.subheadline)
                            .foregroundColor(.black05)
                    }
                    
                    Spacer()
                }
                
                Button {
                    viewStore.send(.view(.onAddProductsButtonTap))
                } label: {
                    Text("Add products")
                        .font(.headlineBold)
                        .foregroundColor(.black)
                        .underline()
                }
            }
            .padding([.leading, .trailing, .top], 24)            
        }
    }
}
