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
    @Bindable var store: StoreOf<HealthKitFeature>
}

// MARK: - Views

extension HealthKitView: View {

    var body: some View {
        content
            .onAppear { self.store.send(.view(.onViewAppear)) }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            HStack(spacing: 60) {
                stepsView(store: store)
                distanceView(store: store)
                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("HealthKit")
        .toolbar(.hidden, for: .tabBar)
        .loader(isLoading: store.isActivityIndicatorVisible)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
    
    private func stepsView(store: StoreOf<HealthKitFeature>) -> some View {
        VStack(alignment: .leading) {
            if let last = store.steps.last {
                Text("Steps")
                    .foregroundColor(.black)
                    .font(.title3)
                
                Text("\(last.value)")
                    .foregroundColor(.black)
                    .font(.title1)
            }
        }
    }
    
    private func distanceView(store: StoreOf<HealthKitFeature>) -> some View {
        VStack(alignment: .leading) {
            if let last = store.distances.last {
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
