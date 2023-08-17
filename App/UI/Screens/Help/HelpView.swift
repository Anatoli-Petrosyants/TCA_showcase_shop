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
    let store: StoreOf<HelpReducer>
    
    struct ViewState: Equatable {
        var showGetStarted: Bool
        var items: [Onboarding]
        @BindingViewState var currentTab: Onboarding.Tab
    }
}

// MARK: - Views

extension HelpView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: \.view, send: { .view($0) }) { viewStore in        
            VStack {
                TabView(selection: viewStore.$currentTab) {
                    ForEach(viewStore.items) { viewData in
                        HelpPageView(data: viewData)
                            .tag(viewData.tab)
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onChange(of: viewStore.currentTab) { newValue in
                    viewStore.send(.onTabChanged(tab: newValue))
                }
                
                Button(Localization.Help.getStarted) {
                    viewStore.send(.onGetStartedTapped)
                }
                .buttonStyle(.cta)
                .padding(.bottom)
                .isHidden(!viewStore.showGetStarted)
            }
            .padding()
        }
    }
}


// MARK: BindingViewStore

extension BindingViewStore<HelpReducer.State> {
    var view: HelpView.ViewState {
        HelpView.ViewState(showGetStarted: self.showGetStarted,
                           items: self.items,
                           currentTab: self.$currentTab)
    }
}

// MARK: HelpPageView

struct HelpPageView: View {
    
    var data: Onboarding

    @State private var isAnimating: Bool = false
    @State private var playLottie = false

    var body: some View {
        VStack() {
            LottieViewRepresentable(name: data.lottie, loopMode: .autoReverse, play: $playLottie)

            Spacer()

            Text(data.title)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(data.description)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .onAppear(perform: {
            playLottie = true
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAnimating = true
            }
        })
    }
}
