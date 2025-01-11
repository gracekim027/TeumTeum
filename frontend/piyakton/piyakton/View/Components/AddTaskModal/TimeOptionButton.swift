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
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center, spacing: 4) {
                Text("\(minutes)분")
                    .font(.body1SemiBold)
                    .foregroundStyle(Color.gray900)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(background)
                    .clipShape(RoundedRectangle(cornerRadius: 80))
                
                Text(description + " " + emoji)
                    .font(.body2Medium)
                    .foregroundStyle(Color.gray400)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.whiteOpacity800)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
