//
//  TodoNewItemView.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 31.03.23.
//

import SwiftUI

struct TodoNewItemView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    
    var addAction: Block<(String, String)>
 
    var body: some View {
        VStack {
            Text("Add Todo")
                .font(.title1)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 10, content: {
                Text("Title")
                TextField("Enter title", text: $title)
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
            })
            .padding(.bottom)

            VStack(alignment: .leading, spacing: 10, content: {
               Text("Description")
               TextField("Enter description", text: $description)
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.gray)
            })
            
            Spacer()
            
            Button("Add") {
                presentationMode.wrappedValue.dismiss()
                addAction((title, description))
            }
            .disabled(title.isEmpty || description.isEmpty)
            .buttonStyle(.cta)
        }
        .padding()
    }
}
