//
//  TimeSelectionButton.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct TimeSelectionButton: View {
    
    let requiredTime: RequiredTime
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .center, spacing: 4) {
                Text("\(requiredTime.rawValue)분")
                    .font(.body1SemiBold)
                    .foregroundStyle(Color.gray900)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(requiredTime.chipColor)
                    .clipShape(RoundedRectangle(cornerRadius: 80))
                
                Text(requiredTime.description)
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
