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

    @State private var openFilePicker: Bool = false
    @State private var taskDescription: String = ""
    
    @FocusState private var isFocused: Bool
    
    let textFieldId: String = "textField"
    
    var body: some View {
        NavigationView {
            if viewModel.showConfirmation {
                VStack(spacing: 0) {
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
                }
                .background(Image("gradient").clipped())
                .background(Color.darkBackground)
            } else {
                ZStack {
                    VStack(spacing: 0) {
                        UploadingFileView(taskList: $viewModel.uploadedFiles) {
                            openFilePicker = true
                        } removeFile: { file in
                            viewModel.removeFile(file)
                        } finishUploading: { time in
                            Task {
                                await viewModel.submitTask(with: time.rawValue)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .fileImporter(isPresented: $openFilePicker,
                                      allowedContentTypes: [.pdf, .movie],
                                      allowsMultipleSelection: true) { result in
                            guard let urlList = try? result.get() else { return }
                            urlList.forEach { viewModel.addFile($0) }
                        }
                    }
                    .onTapGesture {
                        isFocused = false
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                isPresented = false
                            } label: {
                                Text("취소")
                                    .font(.body1Medium)
                                    .foregroundStyle(Color.whiteOpacity700)
                            }
                        }
                    }
                    .padding(.bottom, 64)
                    .ignoresSafeArea(.keyboard)
                    
                    if isFocused {
                        Color.black.opacity(0.7)
                            .ignoresSafeArea(.all)
                            .onTapGesture {
                                isFocused = false
                            }
                    }
                    
                    VStack(spacing: 16) {
                        Spacer()
                        if isFocused {
                            Text("⛳️ 학습 목적에 맞게 요약해드릴게요")
                                .font(.body1Regular)
                                .foregroundStyle(Color.gray50)
                        }
                        MessageField(text: $taskDescription, placeholder: "배우고 싶은 목적은?") {
                            withAnimation(.easeInOut) {
                                //showTimeSelectionPopup = true
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, isFocused ? 20 : 6)
                        .focused($isFocused)
                        .onTapGesture {
                            isFocused = true
                        }
                        .id(textFieldId)
                    }
                }
                .background(Image("gradient").clipped())
                .background(Color.darkBackground)
            }
        }
    }
}
