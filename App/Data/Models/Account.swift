//
//  Account.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 04.07.23.
//

import Foundation

struct Account: Identifiable, Equatable {
    var id = UUID()
    var token = ""
    var firstName = ""
    var lastName = ""
    var birthDate = Date()
    var gender = ""
    var email = ""
    var phone = ""
    var enableNotifications = false
}
