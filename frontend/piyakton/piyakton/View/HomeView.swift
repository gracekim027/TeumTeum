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
            Button {
                isAddTaskModalPresented = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
            }
        }
        .padding()
        .sheet(isPresented: $isAddTaskModalPresented) {
            AddTaskModalView(isPresented: $isAddTaskModalPresented)
                .presentationDetents([.height(1000)])
                .presentationDragIndicator(.visible)
        }
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
