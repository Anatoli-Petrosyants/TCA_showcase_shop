//
//  BasketTopPicksView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 15.09.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - BasketTopPicksView

struct BasketTopPicksView {
    let store: StoreOf<BasketTopPicksReducer>
}

// MARK: - Views

extension BasketTopPicksView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            BasketTopPicksCountView(count: viewStore.topPicks.count)
                .padding([.leading, .trailing], 24)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
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
        .padding([.leading, .trailing], 12)
    }
}
