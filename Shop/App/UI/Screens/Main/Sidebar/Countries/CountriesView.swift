//
//  CountriesView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - CountriesView

struct CountriesView {
    let store: StoreOf<CountriesFeature>
}

// MARK: - Views

extension CountriesView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(viewStore.countryCodes, id: \.self) { countryCode in
                HStack {
                    Text(countryCode.countryFlag())
                    Text(countryCode.countryName(with: countryCode))
                    Spacer()
                    Text(countryCode)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewStore.send(.view(.onItemTap(code: countryCode)))
                }
            }
            .environment(\.defaultMinListRowHeight, 44)
            .listRowBackground(Color.clear)
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Countries")
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

