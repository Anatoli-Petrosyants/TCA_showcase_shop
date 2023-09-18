//
//  MapView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.07.23.
//

import SwiftUI
import ComposableArchitecture
import MapKit
import CoreLocationUI
import SDWebImageSwiftUI

// MARK: - MapView

struct MapView {
    let store: StoreOf<MapReducer>
}

// MARK: - Views

extension MapView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Map(coordinateRegion: viewStore.binding(
                                    get: \.mapRegion,
                                    send: MapReducer.Action.mapRegionChanged(_:)
                                ),
                    annotationItems: viewStore.annotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            WebImage(url: URL(string: annotation.path))
                                .resizable()
                                .placeholder(Image(systemName: "photo"))
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .clipped()
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 4)
                                )
                                .frame(width: 30, height: 30)
                        }
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Map")
            .toolbar(.hidden, for: .tabBar)           
        }
    }
}
