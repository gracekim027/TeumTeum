//
//  AddTaskModalView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct AddTaskModalView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @Binding var isPresented: Bool
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if viewModel.showConfirmation {
                        UploadConfirmView(isPresented: $isPresented)
                            .background(.black)
                            .padding(.top, 80)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button {
                                        isPresented = false
                                    } label: {
                                        Text("닫기")
                                            .font(.body1Medium)
                                            .foregroundStyle(Color.whiteOpacity700)
                                    }
                                }
                            }
                    } else {
                        UploadingFileView()
                        
                        // Task Description Input
                        if isEditing {
                            VStack(spacing: 0) {
                                Spacer()
                                HStack {
                                    Text("⛳️")
                                    Text("학습 목적에 맞게 요약해드릴게요")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                
                                HStack {
                                    TextField("시험공부를 위해", text: $viewModel.taskDescription)
                                        .focused($isFocused)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .padding(.horizontal)
                                    
                                    Button(action: {
                                        isFocused = false
                                        isEditing = false
                                        viewModel.isShowingTimeSelection = true
                                    }) {
                                        HStack(spacing: 4) {
                                            Text("완료")
                                            Image(systemName: "chevron.right")
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                    }
                                    .padding(.trailing)
                                }
                                .padding(.vertical, 8)
                                .background(Color(.systemBackground))
                            }
                        }
                    }
                }
                .onAppear {
                    //viewModel.showConfirmation = true
                }
                
                if viewModel.isShowingTimeSelection {
                    TimeSelectionView(
                        isPresented: $viewModel.isShowingTimeSelection,
                        selectedTime: $viewModel.selectedTime,
                        onTimeSelected: {
                            viewModel.isShowingTimeSelection = false
                            viewModel.showConfirmation = true // Trigger confirmation content
                        }
                    )
                }
            }
            .sheet(isPresented: $viewModel.isShowingFilePicker) {
                DocumentPicker(types: [.pdf, .movie]) { urls in
                    for url in urls {
                        viewModel.addFile(url)
                    }
                }
            }
            .animation(.default, value: isEditing)
        }
    }
}

