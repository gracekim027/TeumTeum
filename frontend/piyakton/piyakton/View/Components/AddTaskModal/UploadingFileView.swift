//
//  UploadingFileView.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

struct UploadingFileView: View {
    
    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible())]
    
    @State private var taskList: [UploadedFile] = []
    @State private var taskDescription: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("틈새 시간에 읽고 싶은\n자료를 올려주세요")
                .font(.header2Bold)
                .foregroundColor(Color.gray50)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 32)
            
            Group {
                if taskList.isEmpty {
                    emptyTaskView()
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(taskList, id: \.id) { file in
                                UploadedFileCell(file: file, state: .uploading) {
                                    // on delete
                                }
                            }
                        }
                    }
                }
            }
            .padding(16)
            .frame(height: 420)
            .frame(maxWidth: .infinity)
            .background(Color.whiteOpacity100)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    // viewModel.showFilePicker()
                    taskList.append(.debug)
                } label: {
                    HStack(spacing: 8) {
                        Image("plus-circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("파일 업로드")
                                .font(.title3SemiBold)
                                .foregroundStyle(Color.gray950)
                                
                            Text("PDF, MP4")
                                .font(.body3Medium)
                                .foregroundStyle(Color.gray600)
                        }
                        
                        Spacer()
                        
                        Text("최대 512mb")
                            .font(.body3Medium)
                            .foregroundStyle(Color.gray500)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 76)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.whiteOpacity500, lineWidth: 0.5)
                )
                
                MessageField(text: $taskDescription, placeholder: "배우고 싶은 목적은?") {
                    // send
                }
            }
        }
        .padding(.top, 28)
        .padding(.horizontal, 24)
        .padding(.bottom, 6)
    }
}

#Preview {
    UploadingFileView()
}

extension UploadingFileView {
    @ViewBuilder private func emptyTaskView() -> some View {
        VStack(spacing: 10) {
            Text("⏰")
                .font(.title2Bold)
            Text("잠깐의 틈도\n채워질 수 있습니다.")
                .font(.body1Regular)
                .foregroundStyle(Color.whiteOpacity700)
                .multilineTextAlignment(.center)
        }
    }
}
