//
//  ProductPhotosView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.07.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - ProductsPhotosView

struct ProductPhotosView {
    let store: StoreOf<ProductPhotosFeature>
}

// MARK: - Views

extension ProductPhotosView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.flexible(), spacing: 8, alignment: .top)]) {
                    ForEach(store.urls, id: \.self) { url in
                        PhotoCell(url: URL(string: url)!)
                    }
                }
                .padding([.leading, .trailing], 8)
                .aspectRatio(1.0, contentMode: .fit)
            }
            .navigationTitle(Localization.Product.detailsPhotos)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.onCloseTap)
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.black)
                    }
                }
            }
        }
    }
}

private struct PhotoCell: View {
    let url: URL

    var body: some View {
        WebImage(url: url)
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
    }
}
