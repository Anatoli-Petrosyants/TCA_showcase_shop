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

struct ContactsClient {
    var requestAccess: @Sendable () async throws -> Bool
    var authorizationStatus: CNAuthorizationStatus
    var contacts: @Sendable () async throws -> [CNContact]
}

extension DependencyValues {
    /// Accessor for the ContactsClient in the dependency values.
    var contactsClient: ContactsClient {
        get { self[ContactsClient.self] }
        set { self[ContactsClient.self] = newValue }
    }
}

extension ContactsClient: DependencyKey {
    static let liveValue: ContactsClient = {
        let store = CNContactStore()
        
        return Self(
            requestAccess: { try await store.requestAccess(for: .contacts) },
            authorizationStatus: {  return CNContactStore.authorizationStatus(for: .contacts) }(),
            contacts: {
                return try await withCheckedThrowingContinuation { continuation in
                    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey]
                    let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
                    var contacts: [CNContact] = []
                    do {
                        try store.enumerateContacts(with: request) { contact, _ in
                            contacts.append(contact)
                        }
                        return continuation.resume(with: .success(contacts))
                    } catch {
                        return continuation.resume(throwing: error)
                    }
                }
            }
        )
    }()
}
