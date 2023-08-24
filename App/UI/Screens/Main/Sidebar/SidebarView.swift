//
//  SidebarView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 21.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - SidebarView

struct SidebarView {
    let store: StoreOf<SidebarReducer>

    struct ViewState: Equatable {
        var isVisible: Bool
        @BindingViewState var isSharePresented: Bool
    }
    
    typealias SidebarReducerViewStore = ViewStore<SidebarView.ViewState, SidebarReducer.Action.ViewAction>
}

// MARK: - Views

extension SidebarView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(.black.opacity(0.6))
                .opacity(viewStore.isVisible ? 1 : 0)
                .animation(.easeInOut.delay(0.1), value: viewStore.isVisible)
                .onTapGesture {                                        
                    viewStore.send(.onDismiss)
                }
                
                HStack(alignment: .top) {
                    ZStack(alignment: .leading) {
                        Color.white
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(Localization.Sidebar.title)
                                .font(.largeTitleBold)
                                .padding(.top, 30)
                            Spacer()
                            settingsView(viewStore: viewStore)
                            featuresView(viewStore: viewStore)
                        }
                        .tint(.black)
                        .padding(24)
                        .padding([.top, .bottom], 24)
                        
                    }
                    .frame(width: Constant.sideBarWidth)
                    .offset(x: viewStore.isVisible ? 0 : -Constant.sideBarWidth)
                    .animation(.default, value: viewStore.isVisible)

                    Spacer()
                }                                    
            }            
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: viewStore.$isSharePresented) {
                ActivityViewRepresentable(activityItems: [Constant.shareURL])
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: BindingViewStore

extension BindingViewStore<SidebarReducer.State> {
    var view: SidebarView.ViewState {
        SidebarView.ViewState(isVisible: self.isVisible,
                              isSharePresented: self.$isSharePresented)
    }
}

// MARK: Views

extension SidebarView {

    private func settingsView(viewStore: SidebarReducerViewStore) -> some View {
        Group {
            Button {
                viewStore.send(.onHealthKitTap)
            } label: {
                Label(Localization.Sidebar.healthKit, systemImage: "cross.case")
            }

            Button {
                viewStore.send(.onCameraTap)
            } label: {
                Label(Localization.Sidebar.camera, systemImage: "camera")
            }

            Button {
                viewStore.send(.onCountriesTap)
            } label: {
                Label(Localization.Sidebar.chooseCountry, systemImage: "house.and.flag")
            }

            Button {
                viewStore.send(.onMapTap)
            } label: {
                Label(Localization.Sidebar.map, systemImage: "map")
            }

            Button {
                viewStore.send(.onMessagesTap)
            } label: {
                Label(Localization.Sidebar.inAppMessages, systemImage: "list.dash.header.rectangle")
            }
        }
    }

    private func featuresView(viewStore: SidebarReducerViewStore) -> some View {
        Group {
            Button {
                viewStore.send(.onDarkModeTap)
            } label: {
                Label(Localization.Sidebar.darkMode, systemImage: "switch.2")
            }
            
            Button {
                viewStore.send(.onVideoPlayerTap)
            } label: {
                Label(Localization.Sidebar.videoPlayer, systemImage: "video")
            }

            Button {
                viewStore.send(.onAppSettings)
            } label: {
                Label(Localization.Sidebar.appSettings, systemImage: "gearshape")
            }

            Button {
                viewStore.send(.onShareTap)
            } label: {
                Label(Localization.Sidebar.shareApp, systemImage: "square.and.arrow.up")
            }

            Button {
                viewStore.send(.onRateTap)
            } label: {
                Label(Localization.Sidebar.rateUs, systemImage: "person.2")
            }

            Button {
                viewStore.send(.onContactTap)
            } label: {
                Label(Localization.Sidebar.contactUs, systemImage: "envelope")
            }

            Button {
                viewStore.send(.onLogoutTap)
            } label: {
                Label(Localization.Base.logout, systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}


