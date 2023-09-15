//
//  BasketEmptyView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 14.09.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

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
                .frame(width: 60, height: 60)
//                .background(Color.black01)
//                .cornerRadius(30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Showcase basket is empty")
                        .font(.headline)

                    Button {

                    } label: {
                        Text("Add products")
                            .font(.headlineBold)
                            .foregroundColor(.black)
                            .underline()
                    }
                }
                
                Spacer()
            }
            
            
            Divider()
            
            BasketTopPicksCountView(count: viewStore.topPicks.count)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(viewStore.topPicks) { product in
                        BasketTopPickView(product: product)
                    }
                }
            }
        }
    }
}

struct BasketTopPicksCountView: View {
    
    var count: Int
    
    var body: some View {
        HStack {
            Text("Top Picks")
                .font(.title3Bold)
            
            Text("(\(count) items)")
                .font(.title3)
            
            Spacer()
        }
    }
}

struct BasketTopPickView: View {

    var product: Product

    var body: some View {
        VStack(spacing: 6) {
            WebImage(url: product.imageURL)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
            
            Text(product.title)
                .font(.footnote)
            
            Text("\(product.price.currency())")
                .font(.body)
            
            Spacer()
        }
        .frame(width: 160, height: 240)
    }
}
