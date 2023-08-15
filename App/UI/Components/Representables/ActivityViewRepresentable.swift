//
//  ShareSheetViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import SwiftUI

struct ActivityViewRepresentable: UIViewControllerRepresentable {
    
    typealias Callback = (_ activityType: UIActivity.ActivityType?,
                          _ completed: Bool,
                          _ returnedItems: [Any]?,
                          _ error: Error?) -> Void
    
    let activityItems: [AnyHashable]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: Context) {
        
    }
}
