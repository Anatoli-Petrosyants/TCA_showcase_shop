//
//  OnboardingView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

// MARK: - OnboardingView

struct OnboardingView {
    @StateObject var container: MVIContainer2<OnboardingIntentProtocol, OnboardingModelStatePotocol>
    private var intent: OnboardingIntentProtocol { container.intent }
    private var state: OnboardingModelStatePotocol { container.model }
    
    @State private var currentTab = 0
    @Environment(\.presentationMode) private var presentationMode
}

// MARK: - Views

extension OnboardingView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
    }
    
    @ViewBuilder private var content: some View {
        
        VStack(spacing: 0) {
            TabView(selection: $currentTab,
                    content:  {
                        ForEach(Onboarding.pages) { viewData in
                            OnboardingPageView(data: viewData)
                                .tag(viewData.id)
                                .padding(.bottom, 50)
                        }
                    })
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            Button("Get Started") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.cta)
                .padding(.bottom)                
                .isHidden(currentTab != 2)
            
            Spacer()
        }
    }
}

// MARK: - Views

private extension OnboardingView {
    
    var emptyView: some View {
        ZStack { Text("Empty View") }
    }
}

//#if DEBUG
//// MARK: - Previews
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        Dependency.shared.resolver.resolve(OnboardingView.self)
//    }
//}
//#endif
