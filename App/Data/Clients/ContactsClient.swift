//
//  ContactsClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 11.09.23.
//

import Foundation
import Contacts
import ComposableArchitecture
import Dependencies

/// A client for interacting with the device's contacts.
struct ContactsClient {
    /// A function to request access to the device's contacts.
    var requestAccess: @Sendable () async throws -> Bool
    
    /// A property to retrieve the current authorization status for contacts.
    var authorizationStatus: CNAuthorizationStatus
    
    /// A function to retrieve the contacts from the device.
    var contacts: @Sendable () async throws -> [Contact]
}

extension DependencyValues {
    /// Accessor for the ContactsClient in the dependency values.
    var contactsClient: ContactsClient {
        get { self[ContactsClient.self] }
        set { self[ContactsClient.self] = newValue }
    }
}

extension ContactsClient: DependencyKey {
    /// A live implementation of ContactsClient.
    static let liveValue: ContactsClient = {
        let store = CNContactStore()
        
        return Self(
            requestAccess: {
                // Attempt to request access to contacts asynchronously.
                // If successful, it returns `true`, otherwise throws an error.
                try await store.requestAccess(for: .contacts)
            },
            authorizationStatus: {
                // Retrieve and return the current authorization status for contacts.
                return CNContactStore.authorizationStatus(for: .contacts)
            }(),
            contacts: {
                return try await withCheckedThrowingContinuation { continuation in
                    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey]
                    let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                    var contacts: [Contact] = []
                    do {
                        // Enumerate through the contacts and convert them to custom Contact objects.
                        try store.enumerateContacts(with: request) { contact, _ in
                            contacts.append(contact.toContact())
                        }
                        // Resume the continuation with the retrieved contacts on success.
                        return continuation.resume(with: .success(contacts))
                    } catch {
                        // Resume the continuation with an error if an exception occurs.
                        return continuation.resume(throwing: error)
                    }
                }
            }
        )
    }()
}

