//
//  Bundle+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.06.23.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
