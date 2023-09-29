//
//  WishlistCardView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import CardStack
import SDWebImageSwiftUI

struct Person: Identifiable {
    let id = UUID()
    let title: String
    let price: Int = { .random(in: 1..<20) }()

    static let mock: [Person] = [
        Person(title: "Niall Miller"),
        Person(title: "Sammy Smart"),
        Person(title: "Edie Bain"),
        Person(title: "Gia Velez"),
        Person(title: "Harri Devine")
    ]
}

struct CardView: View {
    let product: Person

    var body: some View {
        GeometryReader { geo in
            VStack {
//                WebImage(url: product.imageURL)
//                    .resizable()
//                    .indicator(.activity)
//                    .transition(.fade(duration: 0.5))
//                    .scaledToFit()
//                    .frame(height: geo.size.width)
//                    .clipped()
                
                HStack {
                    Text(self.product.title)
                    Spacer()
                    Text("\(product.price) km away")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}

struct CardViewWithThumbs: View {
    let product: Person
    let direction: LeftRight?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .topLeading) {
                CardView(product: product)
            
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .foregroundColor(Color.green)
                    .opacity(direction == .right ? 1 : 0)
                    .frame(width: 100, height: 100)
                    .padding()
            }

            Image(systemName: "hand.thumbsdown.fill")
                .resizable()
                .foregroundColor(Color.red)
                .opacity(direction == .left ? 1 : 0)
                .frame(width: 100, height: 100)
                .padding()
        }
        .animation(.default)
    }
}
