//
//  RemoteImage.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import Foundation

struct RemoteImage {
    let path: String
}

extension RemoteImage: Identifiable {
    var id: String { path }
}
