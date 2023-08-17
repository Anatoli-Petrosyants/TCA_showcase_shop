//
//  ProductAnnouncementView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - ProductAnnouncementView

struct ProductAnnouncementView {
    let store: StoreOf<ProductAnnouncementReducer>
    
    @Namespace private var namespace
    @State private var isAnnouncementZoomed = false
    var maxHeight: Double {
        isAnnouncementZoomed ? 600 : 200
    }
}

// MARK: - Views

extension ProductAnnouncementView: View {
    
    typealias ProductAnnouncementReducerViewStore = ViewStore<ProductAnnouncementReducer.State, ProductAnnouncementReducer.Action>
    
    var body: some View {
        content
            .onAppear { self.store.send(.onViewAppear) }
            .onTapGesture {
                withAnimation(.spring()) {
                    isAnnouncementZoomed.toggle()
                }
            }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.url) { viewStore in
            ZStack {
                imageView(url: viewStore.state)
                
                Text(Localization.Product.announcementTitle)
                    .font(.largeTitleBold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 16, idealHeight: maxHeight)
            .cornerRadius(8)
            .contentShape(Rectangle())
            .padding(6)
            .padding([.top, .bottom], 8)
        }
    }
}

// MARK: Views

extension ProductAnnouncementView {
    
    private func imageView(url: URL) -> some View {
        WebImage(url: url)
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
    }
}
