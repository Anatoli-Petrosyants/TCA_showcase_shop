//
//  LoginEmailRequest.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 08.09.23.
//

struct LoginEmailRequest: Encodable {
    let username: String
    let password: String

    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
