//
//  RemoteImagesCardView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 28.03.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct RemoteImagesCardViewModel: Hashable {
    
    let index: Int
    let path: String
    
    var title: String {
       return "Photo \(index)"
    }
    
    var url: URL? {
       return URL(string: path)
    }
}

struct RemoteImagesCardView: View {
    
    let vm: RemoteImagesCardViewModel
    
    @GestureState private var scaleAmount: CGFloat = 1

    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating(
                $scaleAmount,
                body: { (value, state, transition) in
                    state = value
                }
            )
    }
    
    var body: some View {
        VStack {
            WebImage(url: vm.url)
                .resizable()
                .placeholder(Image(systemName: "photo"))
                .placeholder {
                    Rectangle()
                        .foregroundColor(.random)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .clipped()
                .cornerRadius(10.0)
                .contentShape(Rectangle())
                .scaleEffect(scaleAmount)
                .animation(.easeInOut, value: scaleAmount)
                .gesture(magnificationGesture)
                // .shareSheet(items: [vm.title, vm.url!])

            Text("Photo \(vm.index)")
                .font(.subheadline)
        }
    }
}
