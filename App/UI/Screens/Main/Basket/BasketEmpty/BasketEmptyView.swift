//
//  BasketEmptyView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ReducerView

struct BasketEmptyView {
    let store: StoreOf<BasketEmptyReducer>
}

// MARK: - Views

extension BasketEmptyView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                LottieViewRepresentable(name: "onboarding_1",
                                        loopMode: .autoReverse,
                                        play:.constant(true))
                .frame(width: 100, height: 100)
                .background(Color.black01)
                .cornerRadius(50)
                
                VStack {
                    Text("Your Showcase basket is empty")
                    Button("Add products") {
//                        viewStore.send(.view(.onAddProductsButtonTap))
                    }
                    .buttonStyle(.cta)
                }
            }            
        }
    }
}
