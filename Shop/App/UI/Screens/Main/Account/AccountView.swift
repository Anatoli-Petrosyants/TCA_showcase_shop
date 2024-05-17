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
    @Bindable var store: StoreOf<AccountFeature>
}

// MARK: - Views

extension AccountView: View {
    
    var body: some View {
        content
            .onAppear { store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder 
    private var content: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Form {
                Section {
                    AccountPhotoView(
                        store: self.store.scope(
                            state: \.accountPhoto,
                            action: \.accountPhoto
                        )
                    )
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text(Localization.Account.sectionPersonal)) {
                    TextField(Localization.Account.sectionPersonalFirstName,
                              text: $store.firstName)
                    .keyboardType(.namePhonePad)
                    .textContentType(.name)

                    TextField(Localization.Account.sectionPersonalLastName,
                              text: $store.lastName)
                    .keyboardType(.namePhonePad)
                    .textContentType(.name)

                    DatePicker(Localization.Account.sectionPersonalBirthDate,
                               selection: $store.birthDate,
                               displayedComponents: .date)

                    Picker(Localization.Account.sectionPersonalGender,
                           selection: $store.gender) {
                        ForEach(AccountFeature.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue.capitalized)
                        }
                    }
                }
                .listRowBackground(Color.gray)

                Section(header: Text(Localization.Account.sectionContact)) {
                    TextField(Localization.Account.sectionContactEmail,
                              text: $store.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)

                    TextField(Localization.Account.sectionContactPhone,
                              text: $store.phone)
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
                
                Section(header: Text(Localization.Account.sectionCity),
                        footer: Text(Localization.Account.sectionCityFooter)) {
                    LabeledContent("Add City") {
                        Text(store.city)
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.onCityTap))
                    }
                }
                .listRowBackground(Color.gray)
                
                Section(header: Text("Contacts Information")) {
                    LabeledContent("Contacts") {
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.onContactsTap))
                    }
                }
                .listRowBackground(Color.gray)

                Section(header: Text(Localization.Account.sectionAdditional)) {
                    DisclosureGroup(Localization.Account.sectionAdditionalAboutMe) {
                        Text(Constant.aboutMe)
                    }

                    LabeledContent(Localization.Account.sectionAdditionalSupportedVersion,
                                   value: store.supportedVersion)

                    LabeledContent(Localization.Account.sectionAdditionalAppVersion,
                                   value: store.appVersion)
                }
                .listRowBackground(Color.gray)
                
                Section(header: Text(Localization.Account.sectionSettings)) {
                    LabeledContent("Permissions") {
                        Text(store.notificationsPermissionStatus)
                        Image(systemName: "chevron.right")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.onPermissionsTap))
                    }
                    
                    Toggle(Localization.Account.sectionSettingsEnableNotifications,
                           isOn: $store.enableNotifications)
                    .tint(Color.blue)

                    Text(Localization.Base.logout)
                        .foregroundColor(.red)
                        .onTapGesture {
                            store.send(.view(.onLogoutTap))
                        }
                        .confirmationDialog($store.scope(state: \.dialog, action: \.dialog))
                }
                .listRowBackground(Color.gray)
            }
            .submitLabel(.done)
            .scrollContentBackground(.hidden)
            .tint(.black)
            .navigationTitle(Localization.Account.title)
            .modifier(NavigationBarModifier())
            .scrollDismissesKeyboard(.immediately)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Localization.Base.save) {
                        store.send(.view(.onSaveTap))
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case let .contacts(store):
                ContactsView(store: store)
            case let .cities(store):
                CitiesView(store: store)
            }
        }
        .sheet(
            item: $store.scope(state: \.permissions, action: \.permissions)
        ) { store in
            PermissionsView(store: store)
        }
        .banner(
            isPresented: store.isPresentedBanner, autoDismiss: .after(3)
        ) {
            Text("asas")
        }
    }
    
//    private var successfullySavedBanner: some View {
//        HStack(alignment: .center, spacing: 11) {
//            Text(Localization.Base.successfullySaved)
//                .font(.body)
//                .bold()
//                .foregroundColor(Color.white)
//        }
//        .frame(width: 183, height: 56)
//        .background(Color(red: 0.15, green: 0.15, blue: 0.15))
//        .cornerRadius(20)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .inset(by: 0.25)
//                .stroke(.white.opacity(0.1), lineWidth: 0.5)
//        )
//        .padding()
//    }
}
