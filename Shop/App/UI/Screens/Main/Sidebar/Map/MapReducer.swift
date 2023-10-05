//
//  MapReducer.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.07.23.
//

import SwiftUI
import ComposableArchitecture
import MapKit
import CoreLocation

struct MapReducer: Reducer {
    
    struct State: Equatable {
        var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: 40.1872,
            longitude: 44.5152
        ), span: MKCoordinateSpan(
            latitudeDelta: 12,
            longitudeDelta: 12
        ))
        
//        var annotations: [MapAnnotationData] = MapAnnotationData.mockedData
        
        var annotations: [MapAnnotationData] = [MapAnnotationData(name: "Yerevan",
                                                                  path: "https://picsum.photos/id/235/400/400",
                                                                  coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                                                                    longitude: .random(in: 43...50)))]
        
        static func == (lhs: MapReducer.State, rhs: MapReducer.State) -> Bool {
            return (lhs.mapRegion.center.latitude == rhs.mapRegion.center.latitude) &&
                   (lhs.mapRegion.center.longitude == rhs.mapRegion.center.longitude)
        }
    }
    
    enum Action: BindableAction, Equatable {
        case mapRegionChanged(MKCoordinateRegion)
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .mapRegionChanged(region):
                state.mapRegion = region
                return .none
                
            case .binding:
                return .none
            }
        }
        
        BindingReducer()
    }
}

extension MKCoordinateRegion: Equatable {}

public func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    return lhs.center.latitude == rhs.center.latitude && lhs.center.longitude == rhs.center.longitude
}

//extension CLLocationCoordinate2D: Equatable {}
//
//public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//}
//
//extension MKCoordinateSpan: Equatable {}
//
//public func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//    return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
//}
