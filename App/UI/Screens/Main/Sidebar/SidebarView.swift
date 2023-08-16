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
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
}

// MARK: - Views

extension SidebarView: View {
    
    typealias SidebarReducerViewStore = ViewStore<SidebarReducer.State, SidebarReducer.Action>
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(.black.opacity(0.6))
                .opacity(viewStore.isVisible ? 1 : 0)
                .animation(.easeInOut.delay(0.1), value: viewStore.isVisible)
                .onTapGesture {                                        
                    viewStore.send(.view(.onDismiss))
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
                    .frame(width: sideBarWidth)
                    .offset(x: viewStore.isVisible ? 0 : -sideBarWidth)
                    .animation(.default, value: viewStore.isVisible)

                    Spacer()
                }
            }            
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: viewStore.binding(\.$isSharePresented)) {
                ActivityViewRepresentable(activityItems: [Constant.shareURL])
                    .presentationDetents([.medium])
            }
        }
    }
}

// MARK: Views

extension SidebarView {
    
    private func settingsView(viewStore: SidebarReducerViewStore) -> some View {
        Group {
            Button {
                viewStore.send(.view(.onHealthKitTap))
            } label: {
                Label(Localization.Sidebar.healthKit, systemImage: "cross.case")
            }
            
            Button {
                viewStore.send(.view(.onCameraTap))
            } label: {
                Label(Localization.Sidebar.camera, systemImage: "camera")
            }
            
            Button {
                viewStore.send(.view(.onCountriesTap))
            } label: {
                Label(Localization.Sidebar.chooseCountry, systemImage: "house.and.flag")
            }
            
            Button {
                viewStore.send(.view(.onMapTap))
            } label: {
                Label(Localization.Sidebar.map, systemImage: "map")
            }
            
            Button {
                viewStore.send(.view(.onMessagesTap))
            } label: {
                Label(Localization.Sidebar.inAppMessages, systemImage: "list.dash.header.rectangle")
            }
        }
    }
    
    private func featuresView(viewStore: SidebarReducerViewStore) -> some View {
        Group {
            Button {
                viewStore.send(.view(.onDarkModeTap))
            } label: {
                Label(Localization.Sidebar.darkMode, systemImage: "switch.2")
            }
            
            Button {
                viewStore.send(.view(.onAppSettings))
            } label: {
                Label(Localization.Sidebar.appSettings, systemImage: "gearshape")
            }

            Button {
                viewStore.send(.view(.onShareTap))
            } label: {
                Label(Localization.Sidebar.shareApp, systemImage: "square.and.arrow.up")
            }
            
            Button {
                viewStore.send(.view(.onRateTap))
            } label: {
                Label(Localization.Sidebar.rateUs, systemImage: "person.2")
            }
            
            Button {
                viewStore.send(.view(.onContactTap))
            } label: {
                Label(Localization.Sidebar.contactUs, systemImage: "envelope")
            }

            Button {
                viewStore.send(.view(.onLogoutTap))
            } label: {
                Label(Localization.Base.logout, systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}


