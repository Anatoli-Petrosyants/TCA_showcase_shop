//
//  ErrorModifier.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 06.03.23.
//

import SwiftUI

struct ErrorModifier: ViewModifier {
    
    let error: Error?
    let retryAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            if let error = error {
                VStack(spacing: 16) {
                    Text("An Error Occured")
                        .font(.title1)
                    
                    Text(error.localizedDescription)
                        .font(.title3)
                        .multilineTextAlignment(.center)

                    Button(action: retryAction, label: {
                        Text("Retry")
                            .foregroundColor(Color.blue)
                            .font(.headlineBold)
                            .padding(.top, 24).padding()
                    })
                }
                .padding()
            }
            else {
                content
            }
        }
    }
}

extension View {
    func onError(error: Error?, action: @escaping () -> Void) -> some View {
        modifier(ErrorModifier(error: error, retryAction: action))
    }
}
