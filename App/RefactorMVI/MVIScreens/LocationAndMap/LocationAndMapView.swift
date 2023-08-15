//
//  LocationAndMapView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//

import SwiftUI
import MapKit
import CoreLocationUI
import SDWebImageSwiftUI

// MARK: - LocationAndMapView

struct LocationAndMapView {
    @StateObject var container: MVIContainer2<LocationAndMapIntentProtocol, LocationAndMapModelStatePotocol>
    private var intent: LocationAndMapIntentProtocol { container.intent }
    private var state: LocationAndMapModelStatePotocol { container.model }
}

// MARK: - Views

extension LocationAndMapView: View {

    var body: some View {
        ZStack {
            content
                .navigationTitle(state.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    intent.execute(action: .onViewApear)
                }
            
            VStack {
                Spacer()

                locationButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding([.bottom, .trailing], 20)
            }
        }
    }
    
    @ViewBuilder private var content: some View {
        switch state.contentState {
        case .loading:
            loadingView
        case let .success(data):
            mapView(data)
        case let .failed(error):
            errorView(error)
        }
    }
}

// MARK: - Views

private extension LocationAndMapView {
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.main)
        }
    }
        
    func mapView(_ data: [MapAnnotationData]) -> some View {
        Map(coordinateRegion: .constant(state.userRegion),
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: data) { location in            
            MapAnnotation(coordinate: location.coordinate) {
                WebImage(url: URL(string: location.path))
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle()
                            .foregroundColor(.random)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .clipped()
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.random, lineWidth: 4)
                    )
                    .frame(width: 30, height: 30)
                    // .shareSheet(items: [URL(string: location.path)!])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var locationButton: some View {
        Button {
            intent.execute(action: .onLocationButtonTap)
        } label: {
            Image(systemName: "location.fill")
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(.black)
                .clipShape(Circle())
        }
    }
    
    func errorView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            intent.execute(action: .onViewApear)
        })
    }
}

//#if DEBUG
//// MARK: - Previews
//
//struct LocationAndMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        Dependency.shared.resolver.resolve(LocationAndMapView.self)
//    }
//}
//#endif
