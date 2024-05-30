//
//  Localization+Basket.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 25.09.23.
//

import SwiftUI

extension Localization {
    enum Basket {
        static var title: LocalizedStringKey { return "basket.title" }
        static var subtotal: LocalizedStringKey { return "basket.subtotal" }
        static var categories: LocalizedStringKey { return "basket.categories" }
        static var topPicks: LocalizedStringKey { return "basket.top.picks" }
        static var checkoutTitle: LocalizedStringKey { return "basket.checkout.title" }
        static var checkoutShippingAddress: LocalizedStringKey { return "basket.checkout.shipping.address" }
        static var checkoutSelectPaymentMethod: LocalizedStringKey { return "basket.checkout.select.payment.method" }
        static var addProductsTitle: LocalizedStringKey { return "basket.add.products.title" }
        static var addProductsEmpty: LocalizedStringKey { return "basket.add.products.empty" }
        static var addProductsTopPicks: LocalizedStringKey { return "basket.add.products.top.picks" }
    }
}
