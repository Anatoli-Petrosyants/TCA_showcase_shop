//
//  MapAnnotationData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//


import Foundation
import CoreLocation

struct MapAnnotationData: Identifiable {
    
    let id = UUID()
    let name: String
    let path: String
    var coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Identifiable {
    
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
