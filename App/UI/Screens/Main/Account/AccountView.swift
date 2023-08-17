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
}

// MARK: - Views

extension AccountView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewLoad)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            EmptyView()
            
//            NavigationStack {
//                Form {
//                    Section(header: Text(Localization.Account.sectionHeaderPersonal)) {
//                        TextField(Localization.Account.sectionHeaderPersonalFirstName,
//                                  text: viewStore.binding(\.$firstName))
//                        .keyboardType(.namePhonePad)
//                        .textContentType(.name)
//
//                        TextField(Localization.Account.sectionHeaderPersonalLastName,
//                                  text: viewStore.binding(\.$lastName))
//                        .keyboardType(.namePhonePad)
//                        .textContentType(.name)
//
//                        DatePicker(Localization.Account.sectionHeaderPersonalBirthDate,
//                                   selection: viewStore.binding(\.$birthDate),
//                                   displayedComponents: .date)
//
//                        Picker(Localization.Account.sectionHeaderPersonalGender,
//                               selection: viewStore.binding(\.$gender)) {
//                            ForEach(AccountReducer.Gender.allCases, id: \.self) { gender in
//                                Text(gender.rawValue.capitalized)
//                            }
//                        }
//                    }
//                    .listRowBackground(Color.gray)
//
//                    Section(header: Text(Localization.Account.sectionHeaderContact)) {
//                        TextField(Localization.Account.sectionHeaderContactEmail,
//                                  text: viewStore.binding(\.$email))
//                        .autocapitalization(.none)
//                        .keyboardType(.emailAddress)
//                        .textContentType(.emailAddress)
//
//                        TextField(Localization.Account.sectionHeaderContactPhone,
//                                  text: viewStore.binding(\.$phone))
//                        .keyboardType(.phonePad)
//                        .textContentType(.telephoneNumber)
//
//                        Link(Localization.Account.sectionHeaderContactLinkedin,
//                             destination: Constant.linkedinURL)
//                        .foregroundColor(Color.blue)
//
//                        Link(Localization.Account.sectionHeaderContactUpwork,
//                              destination: Constant.upworkURL)
//                        .foregroundColor(Color.blue)
//                    }
//                    .listRowBackground(Color.gray)
//
//                    Section(header: Text(Localization.Account.sectionHeaderAdditional)) {
//                        DisclosureGroup(Localization.Account.sectionHeaderAdditionalAboutMe) {
//                            Text(Constant.aboutMe)
//                        }
//
//                        LabeledContent(Localization.Account.sectionHeaderAdditionalSupportedVersion,
//                                       value: viewStore.supportedVersion)
//
//                        LabeledContent(Localization.Account.sectionHeaderAdditionalAppVersion,
//                                       value: viewStore.appVersion)
//                    }
//                    .listRowBackground(Color.gray)
//
//                    Section(header: Text(Localization.Account.sectionHeaderSettings)) {
//                        Toggle(Localization.Account.sectionHeaderSettingsEnableNotifications,
//                               isOn: viewStore.binding(\.$enableNotifications))
//
//                        Text(Localization.Base.logout)
//                            .foregroundColor(.red)
//                            .onTapGesture {
//                                viewStore.send(.view(.onLogoutTap))
//                            }
//                    }
//                    .listRowBackground(Color.gray)
//                }
//                .submitLabel(.done)
//                .scrollContentBackground(.hidden)
//                .tint(.black)
//                .navigationTitle(Localization.Account.title)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(Localization.Base.save) {
//                            viewStore.send(.view(.onSaveTap))
//                        }
//                    }
//                }
//            }
            // TODO: binding  state
//            .popup(item: viewStore.binding(\.$toastMessage)) { message in
//                Text(message)
//                    .frame(width: 340, height: 60)
//                    .font(.body)
//                    .foregroundColor(Color.white)
//                    .background(Color.black)
//                    .cornerRadius(30.0)
//            } customize: {
//                $0
//                 .type(.floater())
//                 .position(.top)
//                 .animation(.spring())
//                 .closeOnTapOutside(true)
//                 .closeOnTap(true)
//                 .autohideIn(3)
//            }
//            .confirmationDialog(store: self.store.scope(state: \.$dialog, action: AccountReducer.Action.dialog))
        }
    }
}
