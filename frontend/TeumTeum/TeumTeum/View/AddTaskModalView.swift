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
                    .fileImporter(isPresented: $openFilePicker, allowedContentTypes: [.pdf, .movie], allowsMultipleSelection: true) { result in
                        guard let urlList = try? result.get() else { return }
                        for url in urlList {
                            viewModel.addFile(url)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    if isFocused {
                        VStack(spacing: 16) {
                            Spacer()
                            Text("⛳️ 학습 목적에 맞게 요약해드릴게요")
                                .font(.body1Regular)
                                .foregroundStyle(Color.gray50)
                        }
                    }
                    
                    Spacer().frame(height: 16)
                    
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
                .background(Image("gradient").clipped())
                .background(Color.darkBackground)
            }
        }
    }
}
