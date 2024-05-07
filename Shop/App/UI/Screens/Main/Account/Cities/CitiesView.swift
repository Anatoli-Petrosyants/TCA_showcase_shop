//
//  CitiesView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - CitiesView

struct CitiesView {
    var store: StoreOf<CitiesFeature>
}

// MARK: - Views

extension CitiesView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            Group {
                (/Loadable<[Place]>.loading).extract(from: store.data).map {
                    ProgressView()
                        .progressViewStyle(.main)
                }
                
                (/Loadable<[Place]>.loaded).extract(from: store.data).map { places in
                    List(places, id: \.self) { place in
                        VStack(alignment: .leading) {
                            Text("\(place.name)")
                                .font(.bodyBold)
                                .foregroundColor((place.name == store.selectedCity) ? Color.blue : Color.black)

                            Text("\(place.description)")
                                .font(.footnote)
                                .foregroundColor((place.name == store.selectedCity) ? Color.blue : Color.black05)
                                .lineLimit(3)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.onItemTap(city: place.name))
                        }
                    }
                    .environment(\.defaultMinListRowHeight, 44)
                    .listRowBackground(Color.clear)
                    .listStyle(.plain)
                }
                
                (/Loadable<[Place]>.failed).extract(from: store.data).map { error in
                    ErrorView(error: error) {
                        store.send(.onViewAppear)
                    }
                }
            }
        }
        .navigationTitle(Localization.Account.sectionCityPlaceholder)
        .toolbar(.hidden, for: .tabBar)

    }
}
