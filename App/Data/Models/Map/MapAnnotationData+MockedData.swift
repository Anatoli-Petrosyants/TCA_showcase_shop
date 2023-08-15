//
//  MapAnnotationData+MockedData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//

import Foundation
import CoreLocation

#if DEBUG

extension MapAnnotationData {

    static let mockedData: [MapAnnotationData] = [
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/235/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/236/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/237/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/238/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/239/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/240/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/241/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/242/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/243/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/244/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/245/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/246/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50))),
        MapAnnotationData(name: "Yerevan",
                          path: "https://picsum.photos/id/247/400/400",
                          coordinate: CLLocationCoordinate2D(latitude: .random(in: 30...45),
                                                                            longitude: .random(in: 43...50)))
    ]
}

#endif
