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

struct Place: Equatable, Hashable {
    let id: String
    let name: String
}

struct FirestoreClient {
    var places: @Sendable () async throws -> [Place]
}

extension DependencyValues {
    var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}

extension FirestoreClient: DependencyKey {
    static let liveValue: Self = {

        let db = Firestore.firestore()

        return Self(
            places: {                
                return try await withCheckedThrowingContinuation { continuation in
                    db.collection("places").getDocuments() { (querySnapshot, error) in
                        if let err = error {
                            continuation.resume(with: .failure(err))
                        } else {
                            let places = querySnapshot!.documents.map { document in
                                Place(id: document.documentID,
                                      name: document.data()["name"])
                            }
                            
                            continuation.resume(returning: places)
                        }
                    }
                }
            }
        )
    }()
}


//print("\(document.documentID) => \(document.data())")
//print("places \(places)")
