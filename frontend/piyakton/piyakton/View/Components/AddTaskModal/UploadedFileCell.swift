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
            HStack {
                            if file.type == .mp3 {
                                Image("audio_icon") // Use your asset name
                                    .resizable()
                                    .frame(width: 24, height: 24) // Adjust size as needed
                                    .padding(4) // Optional padding
                            } else if file.type == .pdf {
                                Image("pdf_icon") // Use your asset name for PDFs
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(4)
                            }
                            
                            Spacer() // Push the rest to the right
                        }
            
            Spacer()
            
            // Could show file name here
            Text(file.name)
        }
        .padding(12)
        .frame(width: 154, height: 140, alignment: .trailing)
        .cornerRadius(12)
    }
}
