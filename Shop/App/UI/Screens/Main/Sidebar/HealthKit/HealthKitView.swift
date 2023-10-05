//
//  HealthKitView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - HealthKitView

struct HealthKitView {
    let store: StoreOf<HealthKitReducer>
}

// MARK: - Views

extension HealthKitView: View {
    
    typealias HealthKitReducerViewStore = ViewStore<HealthKitReducer.State, HealthKitReducer.Action>
    
    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in            
            VStack {
                HStack(spacing: 60) {
                    stepsView(viewStore: viewStore)
                    distanceView(viewStore: viewStore)
                    Spacer()
                }

                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("HealthKit")
            .toolbar(.hidden, for: .tabBar)
            .loader(isLoading: viewStore.isActivityIndicatorVisible)
            .alert(store: self.store.scope(state: \.$alert, action: HealthKitReducer.Action.alert))
        }        
    }
    
    private func stepsView(viewStore: HealthKitReducerViewStore) -> some View {
        VStack(alignment: .leading) {
            if let last = viewStore.steps.last {
                Text("Steps")
                    .foregroundColor(.black)
                    .font(.title3)
                
                Text("\(last.value)")
                    .foregroundColor(.black)
                    .font(.title1)
            }
        }
    }
    
    private func distanceView(viewStore: HealthKitReducerViewStore) -> some View {
        VStack(alignment: .leading) {
            if let last = viewStore.distances.last {
                Text("Distance")
                    .foregroundColor(.black)
                    .font(.title3)
                
                Text("\(MeasurementFormatter().string(from: last.value))")
                    .foregroundColor(.black)
                    .font(.title1)
            }
        }
    }
}
