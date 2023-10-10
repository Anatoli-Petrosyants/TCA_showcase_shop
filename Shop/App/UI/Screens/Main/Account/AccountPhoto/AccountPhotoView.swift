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
    let store: StoreOf<AccountPhotoFeature>

    struct ViewState: Equatable {
        var placholder: UIImage
        var photo: UIImage?
        @BindingViewState var isImagePickerPresented: Bool
        var pickerSourceType: UIImagePickerController.SourceType
    }
}

// MARK: - Views

extension AccountPhotoView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            HStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 8) {                    
                    if let photo = viewStore.photo {
                        Image(uiImage: photo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black05, lineWidth: 2))
                    } else {
                        Image(uiImage: viewStore.placholder)
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
                    viewStore.send(.onAddPhotoButtonTap)
                }
                // .redacted(reason: .placeholder)
                
                Spacer()
            }
            .confirmationDialog(store: self.store.scope(state: \.$dialog, action: AccountPhotoFeature.Action.dialog))
            .sheet(isPresented: viewStore.$isImagePickerPresented) {
                ImagePicker(sourceType: viewStore.pickerSourceType) {
                    viewStore.send(.onPhotoSelected($0))
                }
                .ignoresSafeArea()
            }            
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<AccountPhotoFeature.State> {
    var view: AccountPhotoView.ViewState {
        AccountPhotoView.ViewState(
            placholder: self.placholder,
            photo: self.photo,
            isImagePickerPresented: self.$isImagePickerPresented,
            pickerSourceType: self.pickerSourceType
        )
    }
}
