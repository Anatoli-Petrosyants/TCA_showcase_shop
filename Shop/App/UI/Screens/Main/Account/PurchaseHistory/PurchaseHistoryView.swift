//
//  PurchaseHistoryView.swift
//  Shop
//
//  Created by Anatoli Petrosyants on 22.08.24.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

// MARK: - CitiesView

struct PurchaseHistoryView {
    var store: StoreOf<PurchaseHistoryFeature>
    
//    @Query(sort: \Purchase.title) var purchases: [Purchase]
//    @Environment(\.modelContext) var modelContext
    
    @Query(FetchDescriptor<Purchase>()) var purchasesQuery: [Purchase]
}

// MARK: - Views

extension PurchaseHistoryView: View {
    
    var body: some View {
        content
            .onAppear { self.store.send(.onAppear) }
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            List {
                ForEach(store.purchases) { purchase in
                    VStack(alignment: .leading) {
                        Text(purchase.title)
                            .font(.headline)

                        // Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
//                .onDelete(perform: deletePurchases)
            }
            .padding(.top, 24)
        }
        .navigationTitle("Purchase History")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
//            Button("Add Samples", action: addSamples)
            
            Button("Add sample", systemImage: "plus") {
                // viewStore.send(.addMovie, animation: .snappy)
            }
        }
        .onChange(of: self.purchasesQuery, initial: true) { _, newValue in
            store.send(.queryChangedPurchases(newValue))            
        }
    }
}

