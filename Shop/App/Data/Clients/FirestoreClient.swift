//
//  FirestoreClient.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 18.08.23.
//

import Foundation
import Dependencies
import FirebaseCore
import FirebaseFirestore
import CodableFirebase

/// A typealias to indicate that `DocumentReference` conforms to `DocumentReferenceType`.
extension DocumentReference: DocumentReferenceType {}

/// A typealias to indicate that `GeoPoint` conforms to `GeoPointType`.
extension GeoPoint: GeoPointType {}

/// A typealias to indicate that `FieldValue` conforms to `FieldValueType`.
extension FieldValue: FieldValueType {}

/// A typealias to indicate that `Timestamp` conforms to `TimestampType`.
extension Timestamp: TimestampType {}

/// A struct representing a place with an `id` and a `name`.
struct Place: Codable, Equatable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
}

/// A struct representing a client for Firestore operations.
struct FirestoreClient {
    /// A closure to fetch places from Firestore asynchronously.
    var places: @Sendable () async throws -> [Place]
}

extension DependencyValues {
    /// Property to access the `FirestoreClient` dependency.
    var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}

extension FirestoreClient: DependencyKey {
    /// A live implementation of `FirestoreClient`.
    static let liveValue: Self = {
        let firestore = Firestore.firestore()
        return Self(
            places: {
                return try await withCheckedThrowingContinuation { continuation in
                    firestore.collection("places").getDocuments() { (querySnapshot, error) in
                        if let err = error {
                            continuation.resume(with: .failure(err))
                        } else {
                            guard let querySnapshot = querySnapshot else {
                                continuation.resume(with: .failure(AppError.general))
                                return
                            }
                            
                            let places: [Place] = querySnapshot.documents.compactMap { document in
                                return try! FirestoreDecoder().decode(Place.self, from: document.data())
                            }
                                                        
                            continuation.resume(returning: places)
                        }
                    }
                }
            }
        )
    }()
}
