//
//  UploadedFileCell.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//
import SwiftUI

struct UploadedFileCell: View {
    let file: UploadedFile  // Using your specific model
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            // Icon and Title in VStack with Leading Alignment
            VStack(alignment: .leading, spacing: 2) {
                if file.type == .mp3 {
                    Image("audio_icon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(4)
                } else if file.type == .pdf {
                    Image("pdf_icon")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(4)
                }
                
                Text(file.name)
                    .font(.caption)
                    .lineLimit(1) // Truncate if too long
                    .foregroundColor(.primary)
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading) // Align to the leading edge
            
            Spacer()
            
            // Delete Button
            HStack(alignment: .center, spacing: 10) {
                Spacer() // Push button to the right
                
                Text("삭제")
                    .font(Font.custom("Interop", size: 14).weight(.semibold))
                    .foregroundColor(Color.Red500)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.WhiteOpacity700)
            .cornerRadius(100)
        }
        .padding(12)
        .frame(width: 154, height: 140, alignment: .trailing) 
        .background(Color.WhiteOpacity800)
        .cornerRadius(12)
    }
}

