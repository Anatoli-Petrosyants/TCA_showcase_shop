//
//  LoginUseCase.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 12.04.23.
//

import Foundation

protocol LoginUseCaseProtocol {
    func execute() async throws -> Bool
}

class LoginUseCase: AsyncThrowsUseCase<Bool>,
                    LoadingUseCaseProtocol {
    
    override func execute() async throws -> Bool {
        try await Task.sleep(for: .seconds(1))
        return true
    }
}

//let messages = try await fetchMessages()
//
//private struct Message: Decodable, Identifiable {
//    let id: Int
//    let from: String
//    let message: String
//}
//
//private func fetchMessages(completion: @escaping ([Message]) -> Void) {
//    let url = URL(string: "https://hws.dev/user-messages.json")!
//
//    URLSession.shared.dataTask(with: url) { data, response, error in
//        if let data = data {
//            if let messages = try? JSONDecoder().decode([Message].self, from: data) {
//                completion(messages)
//                return
//            }
//        }
//
//        completion([])
//    }.resume()
//}
//
//private func fetchMessages() async throws -> [Message] {
//    await withCheckedContinuation { continuation in
//        fetchMessages { messages in
//            continuation.resume(returning: messages)
//        }
//    }
//}


