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
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Account Photo")
        }
    }
}
