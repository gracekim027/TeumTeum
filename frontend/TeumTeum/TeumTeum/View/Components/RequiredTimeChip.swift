//
//  RequiredTimeChip.swift
//  TeumTeum
//
//  Created by 최유림 on 1/12/25.
//

import SwiftUI

struct RequiredTimeChip: View {
    
    let requiredTime: RequiredTime
    
    var body: some View {
        Text("\(requiredTime.rawValue)분")
            .font(.caption1SemiBold)
            .foregroundStyle(Color.gray900)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(requiredTime.chipColor)
            .clipShape(RoundedRectangle(cornerRadius: 100))
    }
}

#Preview {
    RequiredTimeChip(requiredTime: .medium)
}
