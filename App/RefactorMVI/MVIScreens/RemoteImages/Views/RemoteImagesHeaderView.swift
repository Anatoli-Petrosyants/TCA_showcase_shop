//
//  RemoteImagesHeaderView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.03.23.
//

import SwiftUI

struct RemoteImagesHeaderView: View {
    
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .foregroundColor(.primary)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
            
            Text(description)
                .font(.title3)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
        }
    }
}
