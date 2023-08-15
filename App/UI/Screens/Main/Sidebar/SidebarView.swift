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
                            Text("Menu")
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
                Label("HealthKit", systemImage: "cross.case")
            }
            
            Button {
                viewStore.send(.view(.onCameraTap))
            } label: {
                Label("Camera", systemImage: "camera")
            }
            
            Button {
                viewStore.send(.view(.onCountriesTap))
            } label: {
                Label("Choose Country", systemImage: "house.and.flag")
            }
            
            Button {
                viewStore.send(.view(.onMapTap))
            } label: {
                Label("Map", systemImage: "map")
            }
            
            Button {
                viewStore.send(.view(.onMessagesTap))
            } label: {
                Label("InApp Messages", systemImage: "list.dash.header.rectangle")
            }
        }
    }
    
    private func featuresView(viewStore: SidebarReducerViewStore) -> some View {
        Group {
            Button {
                viewStore.send(.view(.onDarkModeTap))
            } label: {
                Label("Dark mode", systemImage: "switch.2")
            }
            
            Button {
                viewStore.send(.view(.onAppSettings))
            } label: {
                Label("App settings", systemImage: "gearshape")
            }

            Button {
                viewStore.send(.view(.onShareTap))
            } label: {
                Label("Share app", systemImage: "square.and.arrow.up")
            }
            
            Button {
                viewStore.send(.view(.onRateTap))
            } label: {
                Label("Rate us", systemImage: "person.2")
            }
            
            Button {
                viewStore.send(.view(.onContactTap))
            } label: {
                Label("Contact us", systemImage: "envelope")
            }

            Button {
                viewStore.send(.view(.onLogoutTap))
            } label: {
                Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
            }
        }
    }
}


