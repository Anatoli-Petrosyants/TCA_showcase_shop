//
//  LoginOptionsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - LoginOptionsView

struct LoginOptionsView {
    let store: StoreOf<LoginOptionsReducer>
}

// MARK: - Views

extension LoginOptionsView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Login options view")
        }
    }
}
