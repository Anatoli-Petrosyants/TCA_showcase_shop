//
//  RemoteImagesGridStack.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.03.23.
//

import SwiftUI

struct RemoteImagesGridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(spacing: 16) {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack(spacing: 16) {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
