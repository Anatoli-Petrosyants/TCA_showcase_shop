//
//  SearchWishlistView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 13.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SearchWishlistView

struct SearchWishlistView {
    let store: StoreOf<SearchWishlistReducer>
}

// MARK: - Views

extension SearchWishlistView: View {
    
    var body: some View {
        content
            .onAppear { ViewStore(self.store).send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Image(systemName: "gift.fill")
                .resizable()
                .tint(.black)
                .frame(width: CGFloat(24),
                       height: CGFloat(24),
                       alignment: .center
                )
                .customBadge(viewStore.count)
        }
    }
}

struct SearchWishlistBadge: ViewModifier {
    let text: Text
    
    func body(content: Content) -> some View {
        ZStack() {
            content
            text
                .frame(width: CGFloat(12),
                       height: CGFloat(12),
                       alignment: .center
                )
                .padding(4)
                .font(.footnote)
                .foregroundColor(.white)
                .background(.red)
                .clipShape(Circle())
                .offset(x: 12, y: -12)
                
        }
    }
}

extension View {

    func customBadge(_ number: Int) -> some View {
        self.modifier(SearchWishlistBadge(text: Text("\(number)")))
    }
}
