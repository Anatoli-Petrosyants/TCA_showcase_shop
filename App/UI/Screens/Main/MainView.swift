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
                        Image(systemName: "house.circle.fill")
                        Text("Products")
                    }
                    .tag(Tab.products)
                    
                    SearchView(
                        store: self.store.scope(
                            state: \.search,
                            action: MainReducer.Action.search
                        )
                    )
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle")
                        Text("Search")
                    }
                    .tag(Tab.search)
                    
                    BasketView(
                        store: self.store.scope(
                            state: \.basket,
                            action: MainReducer.Action.basket
                        )
                    )
                    .tabItem {
                        Image(systemName: "basket.fill")
                        Text("Basket")
                    }
                    .tag(Tab.basket)
                    
                    AccountView(
                        store: self.store.scope(
                            state: \.account,
                            action: MainReducer.Action.account
                        )
                    )
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Account")
                    }
                    .tag(Tab.account)
                }
                .accentColor(.black)
                
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
