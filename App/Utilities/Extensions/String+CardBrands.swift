//
//  String+CardBrands.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.09.23.
//

import SwiftUI

extension String {
    
    enum CardBrand: String {
        case unknown = "Unknown"
        case visa = "Visa"
        case mastercard = "MasterCard"
        case amex = "American Express"
        case discover = "Discover"
        case dinersClub = "Diners Club"
        case jcb = "JCB"
        
        var image: String {
            switch self {                
            case .unknown:
                return "ic_card_unknown"
            case .visa:
                return "ic_card_visa"
            case .mastercard:
                return "ic_card_mastercard"
            case .amex:
                return "ic_card_amex"
            case .discover:
                return "ic_card_discover"
            case .dinersClub:
                return "ic_card_diners"
            case .jcb:
                return "ic_card_jcb"
            }
        }
    }

    var cardBrand: CardBrand {
        let cardNumber = self.replacingOccurrences(of: " ", with: "")
        let cardPrefix = String(cardNumber.prefix(6))

        let cardPatterns: [CardBrand: String] = [
            .visa: "^4[0-9]{0,15}$",
            .mastercard: "^5[1-5][0-9]{0,14}$",
            .amex: "^3[47][0-9]{0,13}$",
            .discover: "^(6011|6221[2-9]|64[4-9]|65)",
            .dinersClub: "^(30[0-5]|36|38)",
            .jcb: "^(35[2-8][0-9])"
        ]

        for (brand, pattern) in cardPatterns {
            if cardPrefix.range(of: pattern, options: .regularExpression) != nil {
                return brand
            }
        }

        return .unknown
    }
}
