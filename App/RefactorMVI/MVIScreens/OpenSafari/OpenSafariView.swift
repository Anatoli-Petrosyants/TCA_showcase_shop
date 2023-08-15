//
//  OpenSafariView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

// MARK: - OpenSafariView

struct OpenSafariView {
    @StateObject var container: MVIContainer2<OpenSafariIntentProtocol, OpenSafariModelStatePotocol>
    private var intent: OpenSafariIntentProtocol { container.intent }
    private var state: OpenSafariModelStatePotocol { container.model }
        
    @State private var showSafariView = false
}

// MARK: - Views

extension OpenSafariView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
            .sheet(isPresented: $showSafariView, content: {
//                SFSafariView(url: state.inAppPath)
//                    .presentationDetents([.large])
            })
    }
    
    @ViewBuilder private var content: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Link(destination: state.outAppPath) {
                Image(systemName: "link.circle.fill")
                Text("Open safari (out of app)")
            }
            .font(.title3)
            
            Text("Open safari (in app)")
                .font(.title3)
                .tint(.red)
                .onTapGesture {
                    showSafariView.toggle()
                }
            
            Button("Open with button (in app)") {
                showSafariView.toggle()
            }
            .buttonStyle(.linkButton)
            
            Spacer()
        })
        .padding()
    }
}

// MARK: - Views

private extension OpenSafariView {
    
    var emptyView: some View {
        ZStack { Text("Empty View") }
    }
}

//#if DEBUG
//// MARK: - Previews
//
//struct OpenSafariView_Previews: PreviewProvider {
//    static var previews: some View {
//        Dependency.shared.resolver.resolve(OpenSafariView.self)
//    }
//}
//#endif
