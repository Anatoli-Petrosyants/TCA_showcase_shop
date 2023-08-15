//
//  CameraView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 03.04.23.
//

import SwiftUI

// MARK: - CameraView

struct CameraV1View {
    @StateObject var container: MVIContainer2<CameraIntentProtocol, CameraModelStatePotocol>
    private var intent: CameraIntentProtocol { container.intent }
    private var state: CameraModelStatePotocol { container.model }
    
    var image: CGImage?
    private let label = Text("Camera feed")
}

// MARK: - Views

extension CameraV1View: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
    }
    
    @ViewBuilder private var content: some View {
        Color.white
          .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Views

private extension CameraV1View {
    
    var emptyView: some View {
        ZStack { Text("Empty View") }
    }
}

//#if DEBUG
//// MARK: - Previews
//
//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        Dependency.shared.resolver.resolve(CameraView.self)
//    }
//}
//#endif
