//
//  CameraView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.07.23.
//

import SwiftUI
import ComposableArchitecture

// MARK: - CameraView

struct CameraView {
    let store: StoreOf<CameraFeature>
}

// MARK: - Views

extension CameraView: View {

    var body: some View {
        content            
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                GeometryReader { geometry in
                    if let image = store.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                    }
                }
                
                Spacer()
                buttonsView(store: store)
                    .padding(.bottom, 44)
            }
            
            if let image = store.state.result {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 200)
                    .offset(x: -5, y: -5)
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Camera")
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    store.send(.onFlipTap)
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                }
            }
        }
    }
    
    private func buttonsView(store: StoreOf<CameraFeature>) -> some View {
        Button {
            store.send(.onTakePhotoTap)
        } label: {
            Image(systemName: "camera.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
        }
    }
}
