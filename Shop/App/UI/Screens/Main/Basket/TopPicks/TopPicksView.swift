//
//  TopPicksView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.09.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - TopPicksView

struct TopPicksView {
    let store: StoreOf<TopPicksFeature>
}

// MARK: - Views

extension TopPicksView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            if viewStore.products.count > 0 {
                TopPicksCountView(count: viewStore.products.count)
                    .padding([.leading, .trailing], 24)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(viewStore.products) { product in
                            TopPickView(product: product)
                                .onTapGesture {
                                    viewStore.send(.view(.onItemTap(product)))
                                }
                        }
                    }
                }
            }          
        }
    }
}

struct TopPicksCountView: View {
    var count: Int
    
    var body: some View {
        HStack {
            Text(Localization.Basket.topPicks)
                .font(.title3Bold)
            
            Text("(\(count) items)")
                .font(.title3)
            
            Spacer()
        }
    }
}

struct TopPickView: View {
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
        .padding([.leading, .trailing], 12)
    }
}
