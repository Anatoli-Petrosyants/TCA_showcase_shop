//
//  ContactsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

import SwiftUI
import ComposableArchitecture
import Contacts

// MARK: - ContactsView

struct ContactsView {
    @Bindable var store: StoreOf<ContactsFeature>
}

// MARK: - Views

extension ContactsView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            Group {
                (/Loadable<[Contact]>.loading).extract(from: store.data).map {
                    ProgressView()
                        .progressViewStyle(.main)
                }

                (/Loadable<[Contact]>.loaded).extract(from: store.data).map { contacts in
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.send(.view(.onContactTap(contact)))
                        }
                    }
                    .environment(\.defaultMinListRowHeight, 44)
                    .listRowBackground(Color.clear)
                    .listStyle(.plain)
                }

                (/Loadable<[Contact]>.failed).extract(from: store.data).map { error in
                    ErrorView(error: error) {
                        store.send(.view(.onOpenSettingsButtonTap))
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        store.send(.view(.onAddButtonTap))
                    }
                }
            }
            .sheet(isPresented: $store.isContactPresented) {
                ContactViewRepresentable(contact: store.contactToShow)
            }
        }
    }
}
