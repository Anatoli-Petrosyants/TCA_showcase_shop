//
//  PhoneLoginView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - PhoneLoginView

struct PhoneLoginView {
    let store: StoreOf<PhoneLoginReducer>
}

// MARK: - Views

extension PhoneLoginView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Phone Login")
        }
    }
}
