//
//  TodoItemView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

struct TodoItemView: View {

    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#if DEBUG
struct TodoItemView_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemView(title: "Title", description: "description")
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
