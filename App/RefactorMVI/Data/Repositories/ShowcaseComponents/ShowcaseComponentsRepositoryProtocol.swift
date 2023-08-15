//
//  ShowcaseComponentsRepositoryProtocol.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

protocol ShowcaseComponentsRepositoryProtocol {
    func components(completion: ResultBlock<[Component]?, Error>?)
}
