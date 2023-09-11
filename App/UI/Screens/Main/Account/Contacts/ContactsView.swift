//
//  ContactsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ContactsView

struct ContactsView {
    let store: StoreOf<ContactsReducer>
}

// MARK: - Views

extension ContactsView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("Contacts")
        }
    }
}
