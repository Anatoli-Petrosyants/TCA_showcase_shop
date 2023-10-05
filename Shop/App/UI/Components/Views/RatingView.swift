//
//  RatingView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 26.06.23.
//

import SwiftUI

struct RatingView: View {
    private static let MAX_RATING: Float = 5
    private static let SIZE: CGFloat = 12.0
    private static let COLOR = Color.orange

    let rating: Float
    private let fullCount: Int
    private let emptyCount: Int
    private let halfFullCount: Int

    init(rating: Float) {
        self.rating = rating
        fullCount = Int(rating)
        emptyCount = Int(RatingView.MAX_RATING - rating)
        halfFullCount = (Float(fullCount + emptyCount) < RatingView.MAX_RATING) ? 1 : 0
    }

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<fullCount, id: \.self) { _ in
                self.fullStar
            }
            ForEach(0..<halfFullCount, id: \.self) { _ in
                self.halfFullStar
            }
            ForEach(0..<emptyCount, id: \.self) { _ in
                self.emptyStar
            }
        }
    }

  private var fullStar: some View {
      Image(systemName: "star.fill")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(RatingView.COLOR)
          .frame(width: RatingView.SIZE, height: RatingView.SIZE)
  }

  private var halfFullStar: some View {
      Image(systemName: "star.lefthalf.fill")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(RatingView.COLOR)
          .frame(width: RatingView.SIZE, height: RatingView.SIZE)
  }

  private var emptyStar: some View {
      Image(systemName: "star")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(RatingView.COLOR)
          .frame(width: RatingView.SIZE, height: RatingView.SIZE)
  }
}
