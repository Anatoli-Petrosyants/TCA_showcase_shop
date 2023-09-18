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
    let store: StoreOf<MainReducer>
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
                TabView(selection: viewStore.binding(send: MainReducer.Action.onTabChanged)) {
                    ProductsView(
                        store: self.store.scope(
                            state: \.products,
                            action: MainReducer.Action.products
                        )
                    )
                    .tabItem {
                        Image(systemName: Tab.products.icon)
                        Text(Tab.products.title)
                    }
                    .tag(Tab.products)

                    SearchView(
                        store: self.store.scope(
                            state: \.search,
                            action: MainReducer.Action.search
                        )
                    )
                    .tabItem {
                        Image(systemName: Tab.search.icon)
                        Text(Tab.search.title)
                    }
                    .tag(Tab.search)

                    BasketView(
                        store: self.store.scope(
                            state: \.basket,
                            action: MainReducer.Action.basket
                        )
                    )
                    .tabItem {
                        Image(systemName: Tab.basket.icon)
                        Text(Tab.basket.title)
                    }
                    .tag(Tab.basket)

                    AccountView(
                        store: self.store.scope(
                            state: \.account,
                            action: MainReducer.Action.account
                        )
                    )
                    .tabItem {
                        Image(systemName: Tab.account.icon)
                        Text(Tab.account.title)
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
                        action: MainReducer.Action.sidebar
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
                Store(initialState: MainReducer.State(), reducer: {
                    MainReducer()
                })
        )
    }
}
#endif
