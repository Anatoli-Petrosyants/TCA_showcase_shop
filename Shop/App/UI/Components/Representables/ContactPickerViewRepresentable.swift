//
//  ContactPickerViewRepresentable.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.09.23.
//

// https://stackoverflow.com/questions/57246685/uiviewcontrollerrepresentable-and-cncontactpickerviewcontroller

import SwiftUI
import ContactsUI

protocol ContactPickerViewControllerDelegate: AnyObject {
    func contactPickerViewControllerDidCancel(_ viewController: ContactPickerViewController)
    func contactPickerViewController(_ viewController: ContactPickerViewController, didSelect contact: CNContact)
}

class ContactPickerViewController: UIViewController, CNContactPickerDelegate {
    weak var delegate: ContactPickerViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.open(animated: animated)
    }
    
    private func open(animated: Bool) {
        let viewController = CNContactPickerViewController()
        viewController.delegate = self
        self.present(viewController, animated: false)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: false) {
            self.delegate?.contactPickerViewControllerDidCancel(self)
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.dismiss(animated: false) {
            self.delegate?.contactPickerViewController(self, didSelect: contact)
        }
    }
}

struct ContactPickerViewRepresentable: UIViewControllerRepresentable {
    final class Coordinator: NSObject, ContactPickerViewControllerDelegate {
        func contactPickerViewController(_ viewController: ContactPickerViewController, didSelect contact: CNContact) {
            
        }
        
        func contactPickerViewControllerDidCancel(_ viewController: ContactPickerViewController) {
            
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ContactPickerViewRepresentable>) -> ContactPickerViewController {
        let result = ContactPickerViewController()
        result.delegate = context.coordinator
        return result
    }
    
    func updateUIViewController(_ uiViewController: ContactPickerViewController,
                                context: UIViewControllerRepresentableContext<ContactPickerViewRepresentable>) {
        
    }
}
