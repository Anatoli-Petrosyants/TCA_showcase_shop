//
//  LocationAndMapIntent.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//

import SwiftUI
import MapKit

protocol LocationAndMapIntentProtocol {
    typealias Action = LocationAndMapIntent.Action
    func execute(action: Action)
}

final class LocationAndMapIntent {
    
    private weak var model: LocationAndMapModelActionsProtocol?
    
    init(model: LocationAndMapModelActionsProtocol) {
        self.model = model
    }
}

// MARK: Actions

extension LocationAndMapIntent {
    enum Action {
        case onViewApear
        case onLocationButtonTap
    }
}

extension LocationAndMapIntent: LocationAndMapIntentProtocol {
    
    func execute(action: Action) {
        switch action {
        case .onViewApear:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.model?.mutate(action: .locations(MapAnnotationData.mockedData))
            }
        case .onLocationButtonTap:
            LocationManager.shared.getLocation { [weak self] location, error in                
                if let error = error {
                    self?.model?.mutate(action: .failed(error: error))
                    return
                }
                
                if let location = location {
                    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    ), span: MKCoordinateSpan(
                        latitudeDelta: 12,
                        longitudeDelta: 12
                    ))
                    
                    self?.model?.mutate(action: .userRegion(region))
                }
            }
        }
    }
}

// MARK: Helpers

private extension LocationAndMapIntent {
    
    
}
