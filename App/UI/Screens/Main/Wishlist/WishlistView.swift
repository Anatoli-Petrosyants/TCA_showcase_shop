//
//  WishlistView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.09.23.
//

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

// MARK: - WishlistView

struct WishlistView {
    let store: StoreOf<WishlistReducer>
}

// MARK: - Views

extension WishlistView: View {
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack(alignment: .center) {
                    if viewStore.products.isEmpty {
                        WishlistEmptyView()
                    } else {
                        VStack(spacing: 0) {
                            ForEach(viewStore.products.reversed()) { product in
                                CardView {
                                    VStack {
                                        WebImage(url: product.imageURL)
                                            .resizable()
                                            .indicator(.activity)
                                            .transition(.fade(duration: 0.5))
                                            .scaledToFit()
                                            .padding()
                                        
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(product.title)
                                                .font(.headlineBold)
                                            
                                            Text(product.description)
                                                .lineLimit(3)
                                                .font(.footnote)
                                                .foregroundColor(.black05)
                                            
                                            Text("\(product.price.currency())")
                                                .font(.body)
                                        }
                                        .padding()
                                    }
                                }
                            }
                            
                            WishlistActionsView(
                                store: self.store.scope(
                                    state: \.actions,
                                    action: WishlistReducer.Action.actions
                                )
                            )
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .navigationTitle("Wishlist (\(viewStore.products.count))")
            }
            .badge(viewStore.products.count)
        }
    }
}

struct WishlistEmptyView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
            
            Text("Add product to wishlist by tapping heart icon.")
                .font(.title2)
                .multilineTextAlignment(.center)
        }
    }
}

struct CardView<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            content()
        }
        .background(Color.white)
        .cornerRadius(16.0)
        .shadow(color: .black01, radius: 10.0)
    }
}

//struct CardView<Content: View>: View {
//
//    // MARK: - Properties
//
//    @State var offset = CGSize.zero
//    @State var color: Color = .black
//    @State var isRemoved = false
//
//    var onCardRemoved: (() -> Void)?
//    var onCardAdded: (() -> Void)?
//    var content: () -> Content
//
//    // MARK: - Initializer
//
//    init(onCardRemoved: (() -> Void)? = nil, onCardAdded: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
//        self.onCardRemoved = onCardRemoved
//        self.onCardAdded = onCardAdded
//        self.content = content
//    }
//
//    // MARK: - Body
//
//    var body: some View {
//        ZStack {
//            content()
//                .frame(width: 320, height: 420)
//
//        }
//        .offset(x: offset.width * 1, y: offset.height * 0.4)
//        .rotationEffect(.degrees(Double(offset.width / 40)))
//        .gesture(
//            DragGesture()
//                .onChanged { gesture in
//                    offset = gesture.translation
//                }
//                .onEnded { _ in
//                    withAnimation {
//                        handleSwipe(width: offset.width)
//                    }
//                }
//        )
//        .opacity(isRemoved ? 0 : 1) // add this modifier to handle card removal
//    }
//
//    // MARK: - Private Methods
//
//    func handleSwipe(width: CGFloat) {
//        switch width {
//        case -500...(-150):
//            onCardRemoved?()
//            offset = CGSize(width: -500, height: 0)
//            isRemoved = true // set isRemoved to true
//        case 150...500:
//            onCardAdded?()
//            offset = CGSize(width: 500, height: 0)
//            isRemoved = true // set isRemoved to true
//        default:
//            offset = .zero
//        }
//    }
//}

//typealias CardActionClosure = (String) -> Void
//
//
//struct CardStackView<Content: View>: View {
//
//    typealias CardActionClosure = () -> Void
//
//    @State private var currentIndex: Int = 0
//    let cards: [CardView<Content>]
//    let cardAction: CardActionClosure
//    var loopCards: Bool = false
//
//    init(cards: [CardView<Content>], cardAction: @escaping CardActionClosure, loopCards: Bool = false) {
//        self.cards = cards
//        self.cardAction = cardAction
//        self.loopCards = loopCards
//    }
//
//    var body: some View {
//        ZStack {
//            ForEach(cards.indices.reversed(), id: \.self) { index in
//                let card = cards[index]
//                if index == currentIndex {
//                    currentCardView(card: card)
//                        .overlay(GeometryReader { geometry in
//                            Color.clear
//                                .onAppear {
//                                    let screen = UIScreen.main.bounds
//                                    let rect = geometry.frame(in: .global)
//                                    if rect.maxY < screen.midY {
//                                        currentIndex += 1
//                                        cardAction()
//                                        if loopCards && currentIndex == cards.count {
//                                            currentIndex = 0
//                                        }
//                                        // Align the next card automatically
//                                        if currentIndex < cards.count {
//                                            cards[currentIndex].offset = .zero
//                                        }
//                                    }
//                                }
//                        })
//                } else if index > currentIndex {
//                    upcomingCardView(card: card, index: index)
//                } else {
//                    pastCardView(card: card, index: index)
//                }
//            }
//        }
//        .padding(.horizontal, 20.0)
//        .onAppear {
//            if currentIndex >= cards.count {
//                currentIndex = loopCards ? 0 : cards.count - 1
//            }
//            while currentIndex < cards.count && cards[currentIndex].isRemoved {
//                currentIndex += 1
//            }
//            // Align the first card automatically
//            if currentIndex < cards.count {
//                cards[currentIndex].offset = .zero
//            }
//        }
//    }
//
//    private func currentCardView(card: CardView<Content>) -> some View {
//        card
//            .animation(.spring())
//            .zIndex(Double(cards.count))
//            .offset(x: 0, y: -10)
//            .rotationEffect(.degrees(Double((currentIndex == 0 ? 0 : currentIndex - 1) * 2)))
//            .gesture(
//                DragGesture()
//                    .onChanged { gesture in
//                        card.offset = gesture.translation
//                    }
//                    .onEnded { _ in
//                        withAnimation {
//                            card.handleSwipe(width: card.offset.width)
//                            if abs(card.offset.width) > 100 {
//                                currentIndex += 1
//                                cardAction()
//                                if loopCards && currentIndex == cards.count {
//                                    currentIndex = 0
//                                }
//                                // Align the next card automatically
//                                if currentIndex < cards.count {
//                                    cards[currentIndex].offset = .zero
//                                }
//                            }
//                            card.offset = .zero
//                        }
//                    }
//            )
//    }
//
//    private func upcomingCardView(card: CardView<Content>, index: Int) -> some View {
//        let isRemoving = currentIndex > index
//        let yOffset = isRemoving ? 10 : 10 + CGFloat(index - currentIndex) * 10
//        return card
//            .animation(.spring())
//            .zIndex(Double(cards.count - index))
//            .offset(x: 0, y: yOffset)
//            .rotationEffect(.degrees(Double((currentIndex - index) * 2)))
//    }
//
//    private func pastCardView(card: CardView<Content>, index: Int) -> some View {
//        let offset = 10 + CGFloat(index - currentIndex) * 10
//        return card
//            .zIndex(Double(index))
//            .offset(x: 0, y: offset)
//            .rotationEffect(.degrees(Double((index - currentIndex) * 2)))
//            .opacity(0)
//            .animation(.spring())
//    }
//}
