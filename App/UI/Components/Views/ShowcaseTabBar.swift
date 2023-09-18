//
//  ShowcaseTabBar.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 15.09.23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case products = "house.circle"
    case search = "magnifyingglass.circle"
    case basket = "basket"
    case account = "person.crop.circle"
}

struct ShowcaseTabBar: View {
    
    @Binding var selectedTab: Tab
    
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
        
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(tab == selectedTab ? 1.35 : 1.1)
                        .foregroundColor(tab == selectedTab ? .black : .black05)
                        .font(.system(size: 20))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
    }
}
