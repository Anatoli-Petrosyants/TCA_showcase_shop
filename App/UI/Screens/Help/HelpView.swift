//
//  HelpView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - HelpView

struct HelpView {
    let store: StoreOf<Help>
}

// MARK: - Views

extension HelpView: View {
    
    var body: some View {
        content
            .onAppear { ViewStore(self.store).send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TabView(selection: viewStore.binding(\.$currentTab)) {
                    ForEach(viewStore.items) { viewData in
                        OnboardingPageView(data: viewData)
                            .tag(viewData.tab)
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onChange(of: viewStore.currentTab) { newValue in
                    viewStore.send(.view(.onTabChanged(tab: newValue)))
                }
                
                Button(Localization.Help.getStarted) {
                    viewStore.send(.view(.onGetStartedTapped))
                }
                .buttonStyle(.cta)
                .padding(.bottom)
                .isHidden(!viewStore.showGetStarted)
            }
            .padding()
        }
    }
}
