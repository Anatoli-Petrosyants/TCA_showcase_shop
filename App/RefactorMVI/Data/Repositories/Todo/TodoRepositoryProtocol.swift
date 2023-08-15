//
//  EditProfilesRepositoryProtocol.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import Foundation

protocol TodoRepositoryProtocol {
    func fetch(completion: ResultBlock<[Todo], Error>?)
    func save(_ item: Todo, completion: ResultBlock<Todo, Error>?)
    func delete(_ item: Todo, completion: ResultBlock<Todo, Error>?)
}
