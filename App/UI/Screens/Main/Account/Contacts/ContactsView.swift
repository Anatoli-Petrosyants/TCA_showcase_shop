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
            NavigationStack {
                VStack {
                    Group {
                        (/Loadable<[Contact]>.loading).extract(from: viewStore.data).map {
                            ProgressView()
                                .progressViewStyle(.main)
                        }

                        (/Loadable<[Contact]>.loaded).extract(from: viewStore.data).map { contacts in
                            List(contacts, id: \.self) { contact in
                                HStack {
                                    Text("\(contact.firstName)")
                                        .font(.bodyBold)

                                    Text("\(contact.lastName)")
                                        .font(.bodyBold)
                                    
                                    Spacer()
                                    
                                    Text("\(contact.organization)")
                                        .font(.body)
                                        .foregroundColor(Color.black05)
                                }
                            }
                            .environment(\.defaultMinListRowHeight, 44)
                            .listRowBackground(Color.clear)
                            .listStyle(.plain)
                        }

                        (/Loadable<[Contact]>.failed).extract(from: viewStore.data).map { error in
                            ErrorView(error: error) {
                                viewStore.send(.view(.onOpenSettings))
                            }
                        }
                    }
                }
                .modifier(NavigationBarModifier())
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(Localization.Base.done) {
                            viewStore.send(.view(.onDone))
                        }
                    }
                }
            }
        }
    }
}
