//
//  RemoteImagesRepositoryProtocol.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

protocol RemoteImagesRepositoryProtocol {
    func components(completion: ResultBlock<[RemoteImage]?, Error>?)
}
