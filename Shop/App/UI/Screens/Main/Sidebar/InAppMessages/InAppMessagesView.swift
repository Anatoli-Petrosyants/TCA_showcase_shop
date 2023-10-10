//
//  InAppMessagesView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.07.23.
//

import SwiftUI
import ComposableArchitecture
import PopupView

// MARK: - InAppMessagesView

struct InAppMessagesView {
    let store: StoreOf<InAppMessagesFeature>
    
    struct ViewState: Equatable {
        @BindingViewState var isToastTopVersion1: Bool
        @BindingViewState var isToastTopVersion2: Bool
        @BindingViewState var isToastBottomVersion1: Bool
        
        @BindingViewState var isPopupMiddleVersion: Bool
        @BindingViewState var isPopupBottomVersion: Bool
    }
}

// MARK: - Views

extension InAppMessagesView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { $0 }) { viewStore in
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Toasts
                    Group {
                        SectionHeader(name: "Toasts", count: 3)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
                                                
                        PopupTypeView(
                            title: "Top version 1",
                            detail: "Top toast only text",
                            isShowing: viewStore.$isToastTopVersion1
                        ) {
                            ToastImage(position: .top)
                        }

                        PopupTypeView(
                            title: "Top version 2",
                            detail: "Top float with picture",
                            isShowing: viewStore.$isToastTopVersion2
                        ) {
                            ToastImage(position: .top)
                        }

                        PopupTypeView(
                            title: "Bottom version 1",
                            detail: "Bottom float with a picture",
                            isShowing: viewStore.$isToastBottomVersion1
                        ) {
                            ToastImage(position: .bottom)
                        }
                    }
                    
                    // Popups
                    Group {
                        SectionHeader(name: "Popups", count: 2)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))

                        PopupTypeView(
                            title: "Middle",
                            detail: "Popup in the middle of the screen",
                            isShowing: viewStore.$isPopupMiddleVersion
                        ) {
                            PopupImage(style: .default)
                        }

                        PopupTypeView(
                            title: "Bottom",
                            detail: "Popup in the bottom of the screen",
                            isShowing: viewStore.$isPopupBottomVersion
                        ) {
                            PopupImage(style: .bottom)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("In app Messages")
            .toolbar(.hidden, for: .tabBar)
            .popup(isPresented: viewStore.$isToastTopVersion1) {
                ToastView()
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(Color(hex: "000000").opacity(0.5))
            }
            .popup(isPresented: viewStore.$isToastTopVersion2) {
                ToastView()
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .autohideIn(3000)
            }
            .popup(isPresented: viewStore.$isToastBottomVersion1) {
                ToastView()
            } customize: {
                $0
                    .type(.floater())
                    .position(.bottom)
                    .dragToDismiss(true)
                    .animation(.spring())
            }
            .popup(isPresented: viewStore.$isPopupMiddleVersion) {
                VStack {
                    Text("The popup view")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 380)
                        .background(Color(hex: "9265F8"))
                        .cornerRadius(30.0)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .closeOnTapOutside(true)
                    .dragToDismiss(true)
                    .backgroundColor(.black.opacity(0.4))
                    .animation(.interpolatingSpring(stiffness: 150, damping: 15))
            }
            .popup(isPresented: viewStore.$isPopupBottomVersion) {
                VStack {
                    Spacer()
                    Text("The popup view")
                        .foregroundColor(.white)
                        .frame(width: 320, height: 180)
                        .background(Color(hex: "9265F8"))
                        .cornerRadius(30.0)
                }
            } customize: {
                $0
                    .isOpaque(true)
                    .closeOnTapOutside(true)
                    .dragToDismiss(true)
                    .backgroundColor(Color(hex: "000000").opacity(0.4))
                    .animation(.interpolatingSpring(stiffness: 150, damping: 15))
            }
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<InAppMessagesFeature.State> {
    var view: InAppMessagesView.ViewState {
        InAppMessagesView.ViewState(isToastTopVersion1: self.$isToastTopVersion1,
                                    isToastTopVersion2: self.$isToastTopVersion2,
                                    isToastBottomVersion1: self.$isToastBottomVersion1,
                                    isPopupMiddleVersion: self.$isPopupMiddleVersion,
                                    isPopupBottomVersion: self.$isPopupBottomVersion)
    }
}
