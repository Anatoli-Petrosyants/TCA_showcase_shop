//
//  WishlistCardView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

//import SwiftUI
//import CardStack
//import SDWebImageSwiftUI
//
//struct WishlistCardView: View {
//    let product: Product
//
//    var body: some View {
//        VStack(spacing: 24) {
//            WebImage(url: product.imageURL)
//                .resizable()
//                .indicator(.activity)
//                .transition(.fade(duration: 0.5))
//                .scaledToFit()
//                .frame(height: 300)
//                .clipped()
//            
//            VStack(alignment: .leading, spacing: 6) {
//                Text(product.title)
//                    .foregroundColor(.black)
//                    .font(.headlineBold)
//                
//                Text(product.description)
//                    .lineLimit(6)
//                    .font(.footnote)
//                    .foregroundColor(.black05)
//                
//                Text("\(product.price.currency())")
//                    .foregroundColor(.black)
//                    .font(.body)
//            }
//            
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(radius: 4)
//    }
//}
//
//struct WishlistCardViewWithThumbs: View {
//    let product: Product
//    let direction: LeftRight?
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            ZStack(alignment: .topLeading) {
//                WishlistCardView(product: product)
//
//                Text("Add")
//                    .font(.largeTitle)
//                    .foregroundColor(Color.green)
//                    .opacity(direction == .right ? 1 : 0)
//                    .padding()
//            }
//
//            Text("Remove")
//                .font(.largeTitle)
//                .foregroundColor(Color.red)
//                .opacity(direction == .left ? 1 : 0)
//                .padding()
//        }
//        .animation(.spring())
//        
////        ZStack {
////            CardView(product: product)
////
////            if direction == .right {
////                Image(systemName: "hand.thumbsup.fill")
////                    .resizable()
////                    .foregroundColor(Color.green)
////                    .opacity(direction == .right ? 1 : 0)
////                    .frame(width: 100, height: 100)
////                    .padding()
////            } else if direction == .left {
////                Image(systemName: "hand.thumbsdown.fill")
////                    .resizable()
////                    .foregroundColor(Color.red)
////                    .opacity(direction == .left ? 1 : 0)
////                    .frame(width: 100, height: 100)
////                    .padding()
////            }
////        }
////        .animation(.spring())
//        
////        ZStack(alignment: .topTrailing) {
////            ZStack(alignment: .topLeading) {
////                CardView(product: product)
////
////                Image(systemName: "hand.thumbsup.fill")
////                    .resizable()
////                    .foregroundColor(Color.green)
////                    .opacity(direction == .right ? 1 : 0)
////                    .frame(width: 100, height: 100)
////                    .padding()
////            }
////
////            Image(systemName: "hand.thumbsdown.fill")
////                .resizable()
////                .foregroundColor(Color.red)
////                .opacity(direction == .left ? 1 : 0)
////                .frame(width: 100, height: 100)
////                .padding()
////        }
////        .animation(.spring())
//    }
//}
