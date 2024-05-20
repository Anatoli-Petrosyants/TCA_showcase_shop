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
    @Bindable var store: StoreOf<SidebarFeature>
}

// MARK: - Views

extension SidebarView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(store.isVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.1), value: store.isVisible)
            .onTapGesture {
                store.send(.view(.onDismiss))
            }
            
            HStack(alignment: .top) {
                ZStack(alignment: .leading) {
                    Color.white
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(Localization.Sidebar.title)
                            .font(.largeTitleBold)
                            .padding(.top, 30)
                        Spacer()
                        // settingsView(store: store)
                        featuresView(store: store)
                    }
                    .tint(.black)
                    .padding(24)
                    .padding([.top, .bottom], 24)
                    
                }
                .frame(width: Constant.sideBarWidth)
                .offset(x: store.isVisible ? 0 : -Constant.sideBarWidth)
                .animation(.default, value: store.isVisible)

                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $store.isSharePresented) {
            ActivityViewRepresentable(activityItems: [Constant.shareURL])
                .presentationDetents([.medium])
        }
        .sheet(
            item: $store.scope(state: \.videoPlayer, action: \.videoPlayer)
        ) { store in
            VideoPlayerView(store: store)
        }
    }
}

// MARK: Views

extension SidebarView {

    private func settingsView(store: StoreOf<SidebarFeature>) -> some View {
        Group {
            Button {
                store.send(.view(.onHealthKitTap))
            } label: {
                Label(Localization.Sidebar.healthKit, systemImage: "cross.case")
            }

            Button {
                store.send(.view(.onCameraTap))
            } label: {
                Label(Localization.Sidebar.camera, systemImage: "camera")
            }

            Button {
                store.send(.view(.onCountriesTap))
            } label: {
                Label(Localization.Sidebar.chooseCountry, systemImage: "house.and.flag")
            }

            Button {
                store.send(.view(.onMapTap))
            } label: {
                Label(Localization.Sidebar.map, systemImage: "map")
            }

            Button {
                store.send(.view(.onMessagesTap))
            } label: {
                Label(Localization.Sidebar.inAppMessages, systemImage: "list.dash.header.rectangle")
            }
            
            Button {
                store.send(.view(.onVideoPlayerTap))
            } label: {
                Label(Localization.Sidebar.videoPlayer, systemImage: "video")
            }
        }
    }

    private func featuresView(store: StoreOf<SidebarFeature>) -> some View {
        Group {
            Button {
                store.send(.view(.onDarkModeTap))
            } label: {
                Label(Localization.Sidebar.darkMode, systemImage: "switch.2")
            }
            
            Button {
                store.send(.view(.onAppSettings))
            } label: {
                Label(Localization.Sidebar.appSettings, systemImage: "gearshape")
            }

            Button {
                store.send(.view(.onShareTap))
            } label: {
                Label(Localization.Sidebar.shareApp, systemImage: "square.and.arrow.up")
            }

            Button {
                store.send(.view(.onRateTap))
            } label: {
                Label(Localization.Sidebar.rateUs, systemImage: "person.2")
            }

            Button {
                store.send(.view(.onContactTap))
            } label: {
                Label(Localization.Sidebar.contactUs, systemImage: "envelope")
            }

            Button {
                store.send(.view(.onLogoutTap))
            } label: {
                Label(Localization.Base.logout, systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}


