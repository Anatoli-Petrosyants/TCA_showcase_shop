//
//  LocationAndMapModel.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//

import SwiftUI
import MapKit

// MARK: - Intent Actions

protocol LocationAndMapModelActionsProtocol: AnyObject {
    typealias Action = LocationAndMapModel.Action
    func mutate(action: Action)
}

// MARK: - View State

protocol LocationAndMapModelStatePotocol {
    typealias ContentState = LocationAndMapModel.ContentState
    var navigationTitle: String { get }
    var contentState: ContentState { get }
    var userRegion: MKCoordinateRegion { get }
}

final class LocationAndMapModel: ObservableObject, LocationAndMapModelStatePotocol {
    
    @Published
    var navigationTitle = "Location and map"
    
    @Published
    var contentState: ContentState = .loading
    
    @Published
    var userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(
        latitude: 40.1872,
        longitude: 44.5152
    ), span: MKCoordinateSpan(
        latitudeDelta: 12,
        longitudeDelta: 12
    ))
}

// MARK: - Actions

extension LocationAndMapModel {
    enum Action {
        case locations([MapAnnotationData])
        case userRegion(MKCoordinateRegion)
        case failed(error: Error)
    }
    
    enum ContentState {
        case loading
        case success(data: [MapAnnotationData])
        case failed(error: Error)
    }
}

extension LocationAndMapModel: LocationAndMapModelActionsProtocol {
    
    func mutate(action: Action) {
        switch action {            
        case let .locations(data):
            contentState = .success(data: data)
        case let .userRegion(region):
            userRegion = region
        case .failed(error: let error):
            contentState = .failed(error: error)
        }
    }
}
