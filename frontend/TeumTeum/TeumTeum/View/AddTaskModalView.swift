//
//  AddTaskModalView.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct AddTaskModalView: View {
    
    @ObservedObject var viewModel: AddTaskViewModel
    @Binding var isPresented: Bool
    
    @State private var isEditing = false
    @State private var openFilePicker: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    if viewModel.showConfirmation {
                        UploadConfirmView(isPresented: $isPresented)
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
                        UploadingFileView(taskList: $viewModel.uploadedFiles, taskDescription: $viewModel.taskDescription) {
                            openFilePicker = true
                        } finishUploading: { time in
                            Task {
                                await viewModel.submitTask(with: time.rawValue)
                            }
                        }
                        
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
            }
            .fileImporter(isPresented: $openFilePicker, allowedContentTypes: [.pdf, .movie], allowsMultipleSelection: true) { result in
                guard let urlList = try? result.get() else { return }
                for url in urlList {
                    viewModel.addFile(url)
                }
            }
            .animation(.default, value: isEditing)
        }
    }
}
