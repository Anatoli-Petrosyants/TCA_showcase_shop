//
//  Product+MockedData.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 19.05.23.
//

import Foundation

#if DEBUG

extension ProductDTO {
    
    static var mockedData: [ProductDTO] {
        [
            .init(
                productId: 1,
                title: "Mens Casual Premium Slim Fit T-Shirts",
                price: 22.3,
                description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
                category: "men's clothing",
                image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
                rating: ProductRatingDTO(rate: 4.6, count: 300)
            ),
            .init(
                productId: 2,
                title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
                price: 109.95,
                description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
                category: "men's clothing",
                image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
                rating: ProductRatingDTO(rate: 4.6, count: 300)
            ),
            .init(
                productId: 3,
                title: "Mens Cotton Jacket",
                price: 55.99,
                description: "Great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day.",
                category: "men's clothing",
                image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
                rating: ProductRatingDTO(rate: 4.6, count: 300)
            )
        ]
    }
}

#endif
