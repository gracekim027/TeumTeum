//
//  TimeOptionButton.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//
import SwiftUI

struct TimeOptionButton: View {
    let minutes: Int
    let description: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .center) {
                    Text("\(minutes)분")
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(emoji)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
    }
}
