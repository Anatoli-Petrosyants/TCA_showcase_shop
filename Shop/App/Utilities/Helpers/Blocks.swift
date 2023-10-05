//
//  Blocks.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import Foundation

typealias EmptyBlock                    = () -> Void
typealias Block<T>                      = (T) -> Void
typealias InputOutputBlock<T, O>        = (T) -> O
typealias ResultBlock<T, E: Error>      = (Result<T, E>) -> Void
typealias URLBlock                      = (URL?) -> Void
