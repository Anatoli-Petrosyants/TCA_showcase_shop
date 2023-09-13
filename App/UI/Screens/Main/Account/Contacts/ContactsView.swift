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
    let store: StoreOf<ContactsReducer>
    
    struct ViewState: Equatable {
        var data: Loadable<[Contact]>
        @BindingViewState var isContactPresented: Bool
        var contactToShow: CNContact?
    }
}

// MARK: - Views

extension ContactsView: View {
    
    var body: some View {
        content.onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewStore.send(.onContactTap(contact))
                            }
                        }
                        .environment(\.defaultMinListRowHeight, 44)
                        .listRowBackground(Color.clear)
                        .listStyle(.plain)
                    }

                    (/Loadable<[Contact]>.failed).extract(from: viewStore.data).map { error in
                        ErrorView(error: error) {
                            viewStore.send(.onOpenSettingsButtonTap)
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            viewStore.send(.onAddButtonTap)
                        }
                    }
                }
                .sheet(isPresented: viewStore.$isContactPresented) {
                    ContactViewRepresentable(contact: viewStore.contactToShow)
                }
            }
        }
    }
}


// MARK: BindingViewStore

extension BindingViewStore<ContactsReducer.State> {
    var view: ContactsView.ViewState {
        ContactsView.ViewState(
            data: self.data,
            isContactPresented: self.$isContactPresented,
            contactToShow: self.contactToShow
        )
    }
}
