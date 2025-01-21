//
//  UploadedFileCell.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct UploadedFileCell: View {
    
    let file: UploadedFile
    let state: FileState
    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 2) {
                Group {
                    if file.type == .mp3 {
                        Image("audio_icon")
                            .resizable()
                    } else if file.type == .pdf {
                        Image("pdf_icon")
                            .resizable()
                    }
                }
                .frame(width: 24, height: 24)
                
                Text(file.name)
                    .font(.body2Medium)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                if let detail = file.detail {
                    Text(detail)
                        .font(.caption1Medium)
                        .foregroundStyle(Color.gray500)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button {
                    onDelete?()
                } label: {
                    Text(state == .uploading ? "삭제" : "대기중")
                        .font(.body2SemiBold)
                        .foregroundStyle(state == .uploading ? Color.red500 : Color.gray700)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                
                .background(Color.whiteOpacity700)
                .clipShape(RoundedRectangle(cornerRadius: 100))
            }
        }
        .padding(12)
        .frame(width: 154, height: 140, alignment: .trailing) 
        .background(Color.whiteOpacity800)
        .cornerRadius(12)
    }
}

#Preview {
    UploadedFileCell(file: .init(name: "한국현대사의 이해", type: .pdf, url: URL(string: "hello")!), state: .uploading, onDelete: {})
}
