//
//  HelpView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 10.04.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - HelpView

struct OnboardingView {
    @Bindable var store: StoreOf<OnboardingFeature>
}

// MARK: - Views

extension OnboardingView: View {

    var body: some View {
        content
    }

    @ViewBuilder private var content: some View {
        VStack {
            TabView(selection: $store.selectedTab) {
                ForEach(store.items) { viewData in
                    OnboardingPageView(data: viewData)
                        .tag(viewData.tab)
                        .padding(.bottom, 50)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button(Localization.Help.getStarted) {
                store.send(.onGetStartedTapped)
            }
            .buttonStyle(.cta)
            .padding(.bottom)
            .isHidden(!store.showGetStarted)
        }
        .padding()
    }
}

// MARK: HelpPageView

struct OnboardingPageView: View {
    
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
