//
//  ProductsRepositoryProtocol.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation

protocol ProductsRepositoryProtocol {
    func fetch(completion: ResultBlock<[Product], Error>?)
}
