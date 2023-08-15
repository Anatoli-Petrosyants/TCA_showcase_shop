//
//  OnboardingPageView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

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

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(data: Onboarding.pages.first!)
    }
}
