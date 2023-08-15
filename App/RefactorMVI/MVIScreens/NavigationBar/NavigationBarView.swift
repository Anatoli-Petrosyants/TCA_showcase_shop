//
//  NavigationBarView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 20.03.23.
//

import SwiftUI

// MARK: - HomeView

struct NavigationBarView: IntentBindingType {
    @StateObject var container: MVIContainer<NavigationBarIntent, NavigationBarModel.State>
    var intent: NavigationBarIntent { container.intent }
    var state: NavigationBarModel.State { intent.state }
}

// MARK: Views

extension NavigationBarView: View {
    
    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarView
            }
            .onAppear {
                intent.execute(action: .onViewApear)
            }
        
            // #dev refactor this part as we have bugs with double alerts and confirmationDialog. A.P.
            .alert("navigation.bar.info.alert.title",
                   isPresented: Binding.constant(state.showInfoAlert)) {
            } message: {
                Text("navigation.bar.info.alert.description")
            }
            .alert("navigation.bar.add.alert.title",
                   isPresented: Binding.constant(state.showAddAlert)) {
                Button("Add") { }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("navigation.bar.add.alert.description")
            }
            .confirmationDialog("navigation.bar.confirmationDialog.title",
                                isPresented: Binding.constant(state.showActionSheet)) {
                Button("Delete", role: .destructive) { }
            } message: {
                Text("navigation.bar.confirmationDialog.description")
            }
    }
    
    @ViewBuilder private var content: some View {
        emptyView
    }
}

// MARK: - Views

private extension NavigationBarView {
    
    var emptyView: some View {
        ZStack { Text("Press Navigation bar buttons") }
    }
    
    var toolbarView: some ToolbarContent {
        NavigationBarToolBar {
        } infoAction: {
            intent.execute(action: .onInfoButtonTap)
        } addAction: {
            intent.execute(action: .onAddButtonTap)
        } deleteAction: {
            intent.execute(action: .onTrashButtonTap)
        }
    }
}

#if DEBUG
// MARK: - Previews

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        SwinjectDependency.shared.resolver.resolve(NavigationBarView.self)
    }
}
#endif
