//
//  HomeItemView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.03.23.
//

import SwiftUI

struct HomeItemView: View {
    
    let component: Component
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(component.name)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
            }

            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
    }
}

#if DEBUG
struct HomeItemView_Previews: PreviewProvider {
    static var previews: some View {
        HomeItemView(component: Component(name: "Userdefaults", type: .userdefaults))
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
#endif
