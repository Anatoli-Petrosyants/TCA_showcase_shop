//
//  RemoteImagesView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.03.23.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - RemoteImagesView

struct RemoteImagesView {
    @StateObject var container: MVIContainer2<RemoteImagesIntentProtocol, RemoteImagesModelStatePotocol>
    private var intent: RemoteImagesIntentProtocol { container.intent }
    private var state: RemoteImagesModelStatePotocol { container.model }
    
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible())
    ]
}

// MARK: - Views

extension RemoteImagesView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
    }
    
    @ViewBuilder private var content: some View {
        switch state.contentState {
        case .loading:
            loadingView
        case let .success(data):
            listView(data)
        case let .failed(error):
            errorView(error)
        }
    }
}

// MARK: - Views

private extension RemoteImagesView {

    var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.main)
        }
    }
    
    func errorView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            intent.execute(action: .onViewApear)
        })
    }
        
    func listView(_ data: [RemoteImagesCardViewModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                Section(header: RemoteImagesHeaderView(title: "Photos", description: "Zoom in/out or long press"),
                        footer: RemoteImagesFooterView(title: "Total \(data.count) photos.")) {
                    ForEach(data, id: \.self) { vm in
                        RemoteImagesCardView(vm: vm)
                    }
                }
            }
            .padding()
        }
        
//        ScrollView {
//            RemoteImagesGridStack(rows: 4, columns: 4) { row, col in
//                RemoteImagesCardView(index: row * 4 + col, path: data[row * 4 + col])
//            }
//        }
//        .padding(16)
        
//        ScrollView {
//            LazyVStack(spacing: 0) {
//                Section(header: RemoteImagesHeaderView(title: "Long press to view"),
//                        footer: RemoteImagesFooterView(title: "Total \(data.count) photos.")) {
//                    ForEach(data, id: \.self) { url in
//                        WebImage(url: url)
//                            .indicator { (isAnimating, progress) in ProgressView() }
//                            .frame(width: 400, height: 400)
//                    }
//                }
//            }
//        }
//        .padding(.top)
    }
}

#if DEBUG
// MARK: - Previews

struct RemoteImagesView_Previews: PreviewProvider {
    static var previews: some View {
        SwinjectDependency.shared.resolver.resolve(RemoteImagesView.self)
    }
}
#endif
