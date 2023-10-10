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
    
    typealias CameraReducerViewStore = ViewStore<CameraFeature.State, CameraFeature.Action>
    
    var body: some View {
        content            
            .onAppear { self.store.send(.onViewAppear) }
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    GeometryReader { geometry in
                        if let image = viewStore.state.image {
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
                    buttonsView(viewStore: viewStore)
                        .padding(.bottom, 44)
                }
                
                if let image = viewStore.state.result {
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
                        viewStore.send(.onFlipTap)
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                    }
                }
            }
        }
    }
    
    private func buttonsView(viewStore: CameraReducerViewStore) -> some View {
        Button {
            viewStore.send(.onTakePhotoTap)
        } label: {
            Image(systemName: "camera.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
        }
    }
}
