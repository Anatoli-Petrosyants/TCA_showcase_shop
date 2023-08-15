//
//  NavigationBarToolBar.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 24.03.23.
//

import SwiftUI

struct NavigationBarToolBar: ToolbarContent {
    var cancelAction: () -> Void
    var infoAction: () -> Void
    var addAction: () -> Void
    var deleteAction: () -> Void
 
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                cancelAction()
            }
        }
        
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            HStack {
                Button(action: {
                    infoAction()
                }, label: {
                    Image(systemName: "info.circle")
                })
                
                Button(action: {
                    addAction()
                }) {
                    Image(systemName: "folder.badge.plus")
                }
                
                Button(action: {
                    deleteAction()
                }) {
                    Image(systemName: "trash")
                        .tint(.red)
                }
            }
        }
    }
}
