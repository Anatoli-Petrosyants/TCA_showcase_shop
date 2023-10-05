//
//  String+Extensions.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
//

import UIKit

extension String {

    func trimmed()-> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replaceAllChars(with char: String) -> String {
        var result = ""
        for _ in self {
            result += char
        }
        return result
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // min 6 characters, max 60
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).*)")
        return passwordPredicate.evaluate(with: self)
    }
}

extension Double {
    
    func currency() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = "$"
        return currencyFormatter.string(from: NSNumber(value: self)) ?? ""
    }    
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

extension String {
    
    func countryName(with countryCode: String) -> String {
        return Locale.current.localizedString(forRegionCode: countryCode) ?? ""
    }
    
    func countryFlag() -> String {
        String(String.UnicodeScalarView(self.unicodeScalars.compactMap {
            UnicodeScalar(127397 + $0.value)
        }))
    }
}

