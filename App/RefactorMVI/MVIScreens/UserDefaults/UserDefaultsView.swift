//
//  UserDefaultsView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

// MARK: - HomeView

struct UserDefaultsView {
    @StateObject var container: MVIContainer2<UserDefaultsIntentProtocol, UserDefaultsModelStatePotocol>
    private var intent: UserDefaultsIntentProtocol { container.intent }
    private var state: UserDefaultsModelStatePotocol { container.model }
}

// MARK: - Views

extension UserDefaultsView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
            .alert("OnBoarding Alert",
                   isPresented: Binding.constant(state.showOnboardingAlert)) {
            } message: {
                Text("OnBoarding description")
            }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            Button(state.showButtonTitle) {
                intent.execute(action: .onShowOnboardingTap)
            }
            .padding()
            
            Button(state.resetButtonTitle, role: .destructive) {
                intent.execute(action: .onResetTap)
            }
            .padding()
        }
    }
}

// MARK: - Views

private extension UserDefaultsView {
    
    var emptyView: some View {
        ZStack { Text("UserDefaults View") }
    }
}
