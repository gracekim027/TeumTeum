//
//  CustomDivider.swift
//  TeumTeum
//
//  Created by 최유림 on 2/12/25.
//

import SwiftUI

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.whiteOpacity200)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
}

#Preview {
    CustomDivider()
}
