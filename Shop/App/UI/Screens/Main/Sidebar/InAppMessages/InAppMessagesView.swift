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
    @Bindable var store: StoreOf<InAppMessagesFeature>
}

// MARK: - Views

extension InAppMessagesView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Toasts
                Group {
                    SectionHeader(name: "Toasts", count: 3)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
                                            
                    PopupTypeView(
                        title: "Top version 1",
                        detail: "Top toast only text",
                        isShowing: $store.isToastTopVersion1
                    ) {
                        ToastImage(position: .top)
                    }

                    PopupTypeView(
                        title: "Top version 2",
                        detail: "Top float with picture",
                        isShowing: $store.isToastTopVersion2
                    ) {
                        ToastImage(position: .top)
                    }

                    PopupTypeView(
                        title: "Bottom version 1",
                        detail: "Bottom float with a picture",
                        isShowing: $store.isToastBottomVersion1
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
                        isShowing: $store.isPopupMiddleVersion
                    ) {
                        PopupImage(style: .default)
                    }

                    PopupTypeView(
                        title: "Bottom",
                        detail: "Popup in the bottom of the screen",
                        isShowing: $store.isPopupBottomVersion
                    ) {
                        PopupImage(style: .bottom)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("In app Messages")
        .toolbar(.hidden, for: .tabBar)
        .popup(isPresented: $store.isToastTopVersion1) {
            ToastView()
        } customize: {
            $0
                .type(.floater())
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(Color(hex: "000000").opacity(0.5))
        }
        .popup(isPresented: $store.isToastTopVersion2) {
            ToastView()
        } customize: {
            $0
                .type(.floater())
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .autohideIn(3000)
        }
        .popup(isPresented: $store.isToastBottomVersion1) {
            ToastView()
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .dragToDismiss(true)
                .animation(.spring())
        }
        .popup(isPresented: $store.isPopupMiddleVersion) {
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
        .popup(isPresented: $store.isPopupBottomVersion) {
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
