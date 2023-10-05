//
//  MainView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - MainView

struct MainView {
    let store: StoreOf<MainFeature>
}

// MARK: - Views

extension MainView: View {
    
    var body: some View {
        content
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.currentTab) { viewStore in
            ZStack {
                TabView(selection: viewStore.binding(send: MainFeature.Action.onTabChanged)) {
                    ProductsView(
                        store: self.store.scope(
                            state: \.products,
                            action: MainFeature.Action.products
                        )
                    )
                    .tabItem {
                        Label(Tab.products.title, systemImage: Tab.products.icon)
                    }
                    .tag(Tab.products)
                    
                    WishlistView(
                        store: self.store.scope(
                            state: \.wishlist,
                            action: MainFeature.Action.wishlist
                        )
                    )
                    .tabItem {
                        Label(Tab.wishlist.title, systemImage: Tab.wishlist.icon)
                    }
                    .tag(Tab.wishlist)

                    BasketView(
                        store: self.store.scope(
                            state: \.basket,
                            action: MainFeature.Action.basket
                        )
                    )
                    .tabItem {
                        Label(Tab.basket.title, systemImage: Tab.basket.icon)
                    }
                    .tag(Tab.basket)
                                        
                    NotificationsView(
                        store: self.store.scope(
                            state: \.notifications,
                            action: MainFeature.Action.notifications
                        )
                    )
                    .tabItem {
                        Label(Tab.notifications.title, systemImage: Tab.notifications.icon)
                    }
                    .tag(Tab.notifications)

                    AccountView(
                        store: self.store.scope(
                            state: \.account,
                            action: MainFeature.Action.account
                        )
                    )
                    .tabItem {
                        Label(Tab.account.title, systemImage: Tab.account.icon)
                    }
                    .tag(Tab.account)
                }
                .accentColor(.black)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                    appearance.backgroundColor = UIColor(Color.gray.opacity(0.2))

                    // Use this appearance when scrolling behind the TabView:
                    UITabBar.appearance().standardAppearance = appearance
                    // Use this appearance when scrolled all the way up:
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                
                SidebarView(
                    store: self.store.scope(
                        state: \.sidebar,
                        action: MainFeature.Action.sidebar
                    )
                )
                .ignoresSafeArea()
            }
        }
    }
}

#if DEBUG
// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store:
                Store(initialState: MainFeature.State(), reducer: {
                    MainFeature()
                })
        )
    }
}
#endif
