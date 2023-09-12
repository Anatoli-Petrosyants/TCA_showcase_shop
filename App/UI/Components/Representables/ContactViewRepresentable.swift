//
//  ContactViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.09.23.
//

import SwiftUI
import ContactsUI

struct ContactViewRepresentable: UIViewControllerRepresentable {

    let contact: CNContact?
        
    func makeUIViewController(context: Context) -> CNContactViewController {
        let viewController = CNContactViewController(forNewContact: contact)
        viewController.allowsEditing = true
        viewController.allowsActions = true
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CNContactViewController, context: Context) {
        // Update any properties or handle callbacks here if needed
    }
}
