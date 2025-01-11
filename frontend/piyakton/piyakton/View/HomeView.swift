//
//  MainTabView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainViewModel
    @State private var isAddTaskModalPresented = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            // Add a button to present the modal
            Button(action: {
                isAddTaskModalPresented = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
            }
        }
        .padding()
        // Add the sheet modifier to present the modal
        .sheet(isPresented: $isAddTaskModalPresented, content: {
            AddTaskModalView(isPresented: $isAddTaskModalPresented)
                .presentationDetents([.height(1000)]) // Adjust height as needed
                .presentationDragIndicator(.visible)
        })
    }
}

extension DIContainer {
    static var preview: DIContainer {
        DIContainer(/* add your dependencies here */)
    }
}

#Preview {
    MainTabView(viewModel: MainViewModel(container: .preview))
}
