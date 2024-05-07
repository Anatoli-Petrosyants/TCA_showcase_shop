//
//  AccountPhotoView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - AccountPhotoView

struct AccountPhotoView {
    @Bindable var store: StoreOf<AccountPhotoFeature>
}

// MARK: - Views

extension AccountPhotoView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                if let photo = store.photo {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black05, lineWidth: 2))
                } else {
                    Image(uiImage: store.placeholder)
                        .renderingMode(.template)
                        .colorMultiply(.black05)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().fill().foregroundColor(Color.black01))
                }
                
                Text("Set New Photo")
                    .font(.body)
            }
            .onTapGesture {
                store.send(.view(.onAddPhotoButtonTap))
            }
            // .redacted(reason: .placeholder)
            
            Spacer()
        }
        .confirmationDialog($store.scope(state: \.dialog, action: \.dialog))
        .sheet(isPresented: $store.isImagePickerPresented) {
            ImagePicker(sourceType: store.pickerSourceType) {
                store.send(.view(.onPhotoSelected($0)))
            }
            .ignoresSafeArea()
        }
    }
}
