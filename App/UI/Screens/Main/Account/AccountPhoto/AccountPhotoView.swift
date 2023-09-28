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
    let store: StoreOf<AccountPhotoReducer>
}

// MARK: - Views

extension AccountPhotoView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 6) {
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))                        
                    
                    Text("Set New Photo")
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    viewStore.send(.view(.onAddPhotoButtonTap))
                }
                
                Spacer()
            }
            .confirmationDialog(store: self.store.scope(state: \.$dialog, action: AccountPhotoReducer.Action.dialog))
        }
    }
}
