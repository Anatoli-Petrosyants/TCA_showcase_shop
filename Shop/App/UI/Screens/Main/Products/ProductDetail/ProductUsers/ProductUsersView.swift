//
//  ProductUsersView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.06.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - ProductUsersView

struct ProductUsersView {
    let store: StoreOf<ProductUsersFeature>
}

// MARK: - Views

extension ProductUsersView: View {
    
    var body: some View {
        content            
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        if store.items.count > 0 {
            VStack(alignment: .leading) {
                ForEach(store.items, id: \.self) { user in
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundColor(.black03)
                            
                            Image(systemName: "person.fill")
                                .frame(width: 40, height: 40)
                        }
                        .frame(width: 60, height: 60)
                        
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.footnoteBold)
                            
                            HStack {
                                Text("email: ")
                                    .font(.footnote)
                                    .foregroundColor(.black05)
                                
                                Text(user.email)
                                    .font(.footnote)
                            }

                            HStack {
                                Text("phone: ")
                                    .font(.footnote)
                                    .foregroundColor(.black05)
                                
                                Text(user.phone)
                                    .font(.footnote)
                            }
                        }
                        .frame(maxHeight: 100)
                    }
                    .padding([.top, .bottom], 8)
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(.black03)
                }
            }
        } else {
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(.main)
                Spacer()
            }
            .frame(height: 80)
        }
    }
}
