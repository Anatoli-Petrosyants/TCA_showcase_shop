//
//  AccountPhotoFeature.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.09.23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AccountPhotoFeature {
    
    @ObservableState
    struct State: Equatable {
        var placeholder = UIImage(named: "ic_photo_ placeholder")!
        var photo: UIImage? = nil
        
        var isImagePickerPresented = false
        var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
        
        @Presents var dialog: ConfirmationDialogState<Action.DialogAction>?
    }
    
    enum Action: Equatable, BindableAction {
        enum ViewAction: Equatable {
            case onAddPhotoButtonTap
            case onPhotoSelected(UIImage)
        }
        
        enum DialogAction: Equatable {
            case onSelectPhotoFromGallery
            case onSelectPhotoFromCamera
            case onRemovePhoto
        }
        
        enum Delegate: Equatable {
            case didPhotoSelected(UIImage)
        }
        
        case view(ViewAction)
        case dialog(PresentationAction<Action.DialogAction>)
        case binding(BindingAction<State>)
        case delegate(Delegate)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            // view actions
            case .view(.onAddPhotoButtonTap):
                state.dialog = ConfirmationDialogState {
                    TextState(Localization.Base.attention)
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState(Localization.Base.cancel)
                    }
                    
                    ButtonState(role: .none, action: .onSelectPhotoFromGallery) {
                        TextState("Open Gallery")
                    }
                    
                    ButtonState(role: .none, action: .onSelectPhotoFromCamera) {
                        TextState("Open Camera")
                    }
                    
                    ButtonState(role: .destructive, action: .onRemovePhoto) {
                        TextState("Remove Photo")
                    }
                } message: {
                    TextState("Choose the option to change the photo")
                }
                return .none
                
            case let .view(.onPhotoSelected(image)):
                state.photo = image
                return .send(.delegate(.didPhotoSelected(image)))
                
            // dialog actions
            case .dialog(.presented(.onSelectPhotoFromGallery)):
                state.pickerSourceType = .photoLibrary
                state.isImagePickerPresented = true
                return .none
                            
            case .dialog(.presented(.onSelectPhotoFromCamera)):
                state.pickerSourceType = .camera
                state.isImagePickerPresented = true
                return .none
                
            case .dialog(.presented(.onRemovePhoto)):
                state.photo = nil
                return .none

            case .dialog, .binding, .delegate:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
    }
}
