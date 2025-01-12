//
//  MessageField.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

struct MessageField: View {
    
    @Binding var text: String
    let placeholder: String
    let send: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField("", text: $text, prompt: Text(placeholder)
                .font(.body1SemiBold)
                .foregroundStyle(Color.grayOpacity700))
                .font(.body1SemiBold)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
            
            Spacer()
            
            Button {
                send()
            } label: {
                Image(isFocused ? "paperplane" : "paperplane-disabled")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
            .disabled(text.isEmpty)
        }
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .frame(height: 52)
        .background(isFocused ? .white : Color.whiteOpacity700)
        .cornerRadius(100)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.whiteOpacity500, lineWidth: 1)
        )
    }
}
