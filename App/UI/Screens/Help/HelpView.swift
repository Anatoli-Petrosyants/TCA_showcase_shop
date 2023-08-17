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
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {        
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                // TODO: binding state
//                TabView(selection: viewStore.binding(\.$currentTab)) {
//                    ForEach(viewStore.items) { viewData in
//                        HelpPageView(data: viewData)
//                            .tag(viewData.tab)
//                            .padding(.bottom, 50)
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle())
//                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//                .onChange(of: viewStore.currentTab) { newValue in
//                    viewStore.send(.view(.onTabChanged(tab: newValue)))
//                }
                
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
