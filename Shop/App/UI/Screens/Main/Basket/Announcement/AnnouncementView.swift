//
//  AnnouncementView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - AnnouncementView

struct AnnouncementView {
    let store: StoreOf<AnnouncementFeature>
    
    @Namespace private var namespace
    @State private var isAnnouncementZoomed = false
    var maxHeight: Double {
        isAnnouncementZoomed ? 600 : 200
    }
}

// MARK: - Views

extension AnnouncementView: View {

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
        ZStack {
            imageView(url: store.url)
            
            Text(Localization.Product.announcementTitle)
                .font(.largeTitleBold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 16, idealHeight: maxHeight)
        .cornerRadius(8)
        .contentShape(Rectangle())        
    }
}

// MARK: Views

extension AnnouncementView {
    
    private func imageView(url: URL) -> some View {
        WebImage(url: url)
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
    }
}
