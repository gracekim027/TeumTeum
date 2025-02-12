//
//  MainView.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var isAddTaskModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            navigationBar()
            
            Image("logo-text-short")
                .padding(.vertical, 24)
            
            // Queued Task List
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    
                }
            }
            .padding(.bottom, 24)
            
            CustomDivider()
            
            List(viewModel.todoGroupList, id: \.id) {
                TaskCardView(todoGroup: $0, mode: .expandable)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.darkBackground)
            }
            .listStyle(.plain)
        }
        .padding(.horizontal, 24)
        .sheet(isPresented: $isAddTaskModalPresented) {
            AddTaskModalView(
                viewModel: AddTaskViewModel(container: viewModel.container),
                isPresented: $isAddTaskModalPresented)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
        }
    }
}

extension MainView {
    @ViewBuilder private func navigationBar() -> some View {
        HStack {
            Button {
                // edit action
            } label: {
                Text("편집")
                    .font(.body1Medium)
                    .foregroundStyle(Color.whiteOpacity700)
                    .padding(.vertical, 4)
            }
            Spacer()
            Button {
                isAddTaskModalPresented = true
            } label: {
                Image("plus-lime")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
        }
        .frame(height: 44)
    }
}
