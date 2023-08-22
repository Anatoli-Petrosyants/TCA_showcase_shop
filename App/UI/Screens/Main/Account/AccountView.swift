//
//  AccountView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 22.06.23.
//

import SwiftUI
import ComposableArchitecture
import PopupView

// MARK: - AccountView

struct AccountView {
    let store: StoreOf<AccountReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var firstName: String
        @BindingViewState var lastName: String
        @BindingViewState var birthDate: Date
        @BindingViewState var gender: AccountReducer.Gender
        @BindingViewState var email: String
        @BindingViewState var phone: String
        @BindingViewState var enableNotifications: Bool
        @BindingViewState var toastMessage: LocalizedStringKey?
        
        var city: String
        var appVersion: String
        var supportedVersion: String
    }
}

// MARK: - Views

extension AccountView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewLoad)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            NavigationStack {
                Form {
                    Section(header: Text(Localization.Account.sectionPersonal)) {
                        TextField(Localization.Account.sectionPersonalFirstName,
                                  text: viewStore.$firstName)
                        .keyboardType(.namePhonePad)
                        .textContentType(.name)

                        TextField(Localization.Account.sectionPersonalLastName,
                                  text: viewStore.$lastName)
                        .keyboardType(.namePhonePad)
                        .textContentType(.name)

                        DatePicker(Localization.Account.sectionPersonalBirthDate,
                                   selection: viewStore.$birthDate,
                                   displayedComponents: .date)

                        Picker(Localization.Account.sectionPersonalGender,
                               selection: viewStore.$gender) {
                            ForEach(AccountReducer.Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue.capitalized)
                            }
                        }
                    }
                    .listRowBackground(Color.gray)
                    
                    Section(header: Text(Localization.Account.sectionCity),
                            footer: Text(Localization.Account.sectionCityFooter)) {
                        VStack {
                            HStack {
                                Text(viewStore.city)
                                Spacer()
                                Button("Add / Edit") {
                                    viewStore.send(.onAddressTap)
                                }
                                .tint(Color.blue)
                            }
                        }
                    }
                    .listRowBackground(Color.gray)

                    Section(header: Text(Localization.Account.sectionContact)) {
                        TextField(Localization.Account.sectionContactEmail,
                                  text: viewStore.$email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)

                        TextField(Localization.Account.sectionContactPhone,
                                  text: viewStore.$phone)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)

                        Link(Localization.Account.sectionContactLinkedin,
                             destination: Constant.linkedinURL)
                        .foregroundColor(Color.blue)

                        Link(Localization.Account.sectionContactUpwork,
                              destination: Constant.upworkURL)
                        .foregroundColor(Color.blue)
                    }
                    .listRowBackground(Color.gray)

                    Section(header: Text(Localization.Account.sectionAdditional)) {
                        DisclosureGroup(Localization.Account.sectionAdditionalAboutMe) {
                            Text(Constant.aboutMe)
                        }

                        LabeledContent(Localization.Account.sectionAdditionalSupportedVersion,
                                       value: viewStore.supportedVersion)

                        LabeledContent(Localization.Account.sectionAdditionalAppVersion,
                                       value: viewStore.appVersion)
                    }
                    .listRowBackground(Color.gray)

                    Section(header: Text(Localization.Account.sectionSettings)) {
                        Toggle(Localization.Account.sectionSettingsEnableNotifications,
                               isOn: viewStore.$enableNotifications)

                        Text(Localization.Base.logout)
                            .foregroundColor(.red)
                            .onTapGesture {
                                viewStore.send(.onLogoutTap)
                            }
                    }
                    .listRowBackground(Color.gray)
                }
                .submitLabel(.done)
                .scrollContentBackground(.hidden)
                .tint(.black)
                .navigationTitle(Localization.Account.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(Localization.Base.save) {
                            viewStore.send(.onSaveTap)
                        }
                    }
                }
            }            
            .popup(item: viewStore.$toastMessage) { message in
                Text(message)
                    .frame(width: 340, height: 60)
                    .font(.body)
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(30.0)
            } customize: {
                $0
                 .type(.floater())
                 .position(.top)
                 .animation(.spring())
                 .closeOnTapOutside(true)
                 .closeOnTap(true)
                 .autohideIn(3)
            }
            .confirmationDialog(store: self.store.scope(state: \.$dialog, action: AccountReducer.Action.dialog))
            .sheet(
                store: self.store.scope(state: \.$address, action: AccountReducer.Action.address),
                content:
                    AccountCitiesView.init(store:)                        
            )
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<AccountReducer.State> {
    var view: AccountView.ViewState {
        AccountView.ViewState(firstName: self.$firstName,
                              lastName: self.$lastName,
                              birthDate: self.$birthDate,
                              gender: self.$gender,
                              email: self.$email,
                              phone: self.$phone,
                              enableNotifications: self.$enableNotifications,
                              toastMessage: self.$toastMessage,
                              city: self.city,
                              appVersion: self.appVersion,
                              supportedVersion: self.supportedVersion)
    }
}
