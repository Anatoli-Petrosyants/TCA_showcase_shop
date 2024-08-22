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
    
    @Query(sort: \Purchase.title) var purchases: [Purchase]
    @Environment(\.modelContext) var modelContext
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
                ForEach(purchases) { purchase in
                    VStack(alignment: .leading) {
                        Text(purchase.title)
                            .font(.headline)

                        // Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
                .onDelete(perform: deletePurchases)
            }
            .padding(.top, 24)
        }
        .navigationTitle("Purchase History")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            Button("Add Samples", action: addSamples)
        }
    }
    
    func addSamples() {
        let sample1 = Purchase(productId: 1, title: "asample1")
//        let sample2 = Purchase(productId: 1, title: "sample2")
//        let sample3 = Purchase(productId: 1, title: "sample3")
//        
        modelContext.insert(sample1)
//        modelContext.insert(sample2)
//        modelContext.insert(sample3)
    }
    
    func deletePurchases(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = purchases[index]
            modelContext.delete(destination)
        }
    }
}

