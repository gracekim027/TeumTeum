//
//  UploadConfirmView.swift
//  TeumTeum
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

struct UploadConfirmView: View {
    
    @Binding var isPresented: Bool
    let uploadedFileList: [UploadedFile]
    
    var body: some View {
        VStack(spacing: 48) {
            VStack(alignment: .center, spacing: 16) {
                Image("check")
                    .resizable()
                    .frame(width: 44, height: 44)
                
                VStack(alignment: .center, spacing: 16) {
                    Text("틈새 자료가 완성되면\n알림을 보내드릴게요")
                        .font(.header1Bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                    Text("1분 ~ 5분내에 완성돼요 :)")
                        .font(.body1Medium)
                        .foregroundStyle(Color.whiteOpacity700)
                }
            }
            if let thumbnailFile = uploadedFileList.first {
                UploadedFileCell(file: thumbnailFile, state: .waiting, totalFileCount: uploadedFileList.count)
            }
            Button {
                isPresented = false
            } label: {
                Text("홈으로 돌아가기")
                    .font(.body1Medium)
                    .foregroundStyle(Color.lime600)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(Color.grayOpacity800)
                    .clipShape(RoundedRectangle(cornerRadius: 100))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
