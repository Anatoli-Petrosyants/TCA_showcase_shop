//
//  HomeView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

// MARK: - HomeView

struct HomeView {
    @StateObject var container: MVIContainer2<HomeIntentProtocol, HomeModelStatePotocol>
    private var intent: HomeIntentProtocol { container.intent }
    private var state: HomeModelStatePotocol { container.model }
}

// MARK: - Views

extension HomeView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
    }
    
    @ViewBuilder private var content: some View {
        switch state.contentState {
        case .loading:
            loadingView
        case let .success(data):
            listView(data)
        case let .failed(error):
            errorView(error)
        }
    }
}

// MARK: - Views

private extension HomeView {
    
    var loadingView: some View {
        VStack {
            ActivityIndicator(isAnimating: .constant(true))
        }
    }
    
    func errorView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.intent.execute(action: .onViewApear)
        })
    }
        
    func listView(_ data: [Component]) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(data, id: \.self) { component in
                    HomeItemView(component: component)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            intent.execute(action: .itemTapped(component, { view in
                                
                            }))
                        }
                }
            }
        }
        .padding(.top)
    }
}

#if DEBUG
// MARK: - Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SwinjectDependency.shared.resolver.resolve(HomeView.self)
    }
}
#endif
