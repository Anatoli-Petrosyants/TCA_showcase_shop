//
//  AccountAddressView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - AccountAddressView

struct AccountAddressView {
    let store: StoreOf<AccountAddressReducer>
}

// MARK: - Views

extension AccountAddressView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List(viewStore.places, id: \.self) { place in
                    VStack(alignment: .leading) {
                        Text("\(place.name)")
                            .font(.bodyBold)
                        
                        Text("\(place.description)")
                            .font(.footnote)
                            .foregroundColor(Color.black05)
                            .lineLimit(3)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewStore.send(.onItemTap(city: place.name))
                    }
                }
                .padding(.top, 16)
                .environment(\.defaultMinListRowHeight, 44)
                .listRowBackground(Color.clear)
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationBarModifier())
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        SearchInputView(
                            store: self.store.scope(
                                state: \.input,
                                action: AccountAddressReducer.Action.input
                            )
                        )
                        .padding(.top, 24)
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
