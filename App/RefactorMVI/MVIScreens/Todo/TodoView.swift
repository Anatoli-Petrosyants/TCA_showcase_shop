//
//  TodoView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 30.03.23.
//

import SwiftUI

// MARK: - TodoView

struct TodoView {
    @StateObject var container: MVIContainer2<TodoIntentProtocol, TodoModelStatePotocol>
    private var intent: TodoIntentProtocol { container.intent }
    private var state: TodoModelStatePotocol { container.model }
    
    @State private var presentAddNewTodo = false
}

// MARK: - Views

extension TodoView: View {

    var body: some View {
        content
            .navigationTitle(state.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: EditButton().tint(.black),
                                trailing: addButton)
            .onAppear {
                intent.execute(action: .onViewApear)
            }
            .sheet(isPresented: $presentAddNewTodo) {
                TodoNewItemView(addAction: { todo in
                    intent.execute(action: .onAdd(title: todo.0, description: todo.1))
                })
                .presentationDetents([.medium])
            }            
    }
    
    @ViewBuilder private var content: some View {
        switch state.contentState {
        case .loading:
            loadingView
        case let .success(data):
            if data.count > 0 {
                listView(data)
            } else {
                Button {
                    presentAddNewTodo = true
                } label: {
                    Label("Add first todo", systemImage: "note.text.badge.plus")
                        .font(.title3)
                        .tint(.black)
                }
            }
        }
    }
}

// MARK: - Views

private extension TodoView {
    
    var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.main)
        }
    }
        
    func listView(_ data: [Todo]) -> some View {
        List {
            Section {
                ForEach(data) { item in
                    TodoItemView(title: item.title,
                                 description: item.description.valueOr(""))
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            } header: {
                Text(state.headerTitle)
            } footer: {
                Text(state.footerTitle)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.grouped)
    }
    
    var addButton: some View {
        return AnyView(Button {
            presentAddNewTodo = true
        } label: {
            Image(systemName: "plus")
                .tint(.black)
        })        
    }
}

// MARK: - Helpers

private extension TodoView {
    
    func onDelete(offsets: IndexSet) {
        intent.execute(action: .onDelete(offsets: offsets))
    }
    
    func onMove(source: IndexSet, destination: Int) {
        intent.execute(action: .onMove(source: source, destination: destination))        
    }
}

//#if DEBUG
//// MARK: - Previews
//
//struct TodoView_Previews: PreviewProvider {
//    static var previews: some View {
//        Dependency.shared.resolver.resolve(TodoView.self)
//    }
//}
//#endif
