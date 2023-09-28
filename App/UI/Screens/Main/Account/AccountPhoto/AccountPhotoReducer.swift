//
//  AccountPhotoReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.09.23.
//

import SwiftUI
import ComposableArchitecture

struct AccountPhotoReducer: Reducer {
    
    struct State: Equatable {
        @PresentationState var dialog: ConfirmationDialogState<Action.DialogAction>?
    }
    
    enum Action: Equatable {
        enum ViewAction: Equatable {
            case onAddPhotoButtonTap
        }
        
        enum DialogAction: Equatable {
            case onSelectPhotoFromGallery
            case onSelectPhotoFromCamera
            case onRemovePhoto
        }
        
        case view(ViewAction)
        case dialog(PresentationAction<Action.DialogAction>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAddPhotoButtonTap):
                Log.debug("onAddPhotoButtonTap")
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
                
            // dialog actions
            case .dialog(.presented(.onSelectPhotoFromGallery)):
                Log.debug("onSelectPhotoFromGallery")
                return .none
                            
            case .dialog(.presented(.onSelectPhotoFromCamera)):
                Log.debug("onSelectPhotoFromCamera")
                return .none
                
            case .dialog(.presented(.onRemovePhoto)):
                Log.debug("onRemovePhoto")
                return .none

            case .dialog:
                return .none
            }
        }
        .ifLet(\.$dialog, action: /Action.dialog)
    }
}
