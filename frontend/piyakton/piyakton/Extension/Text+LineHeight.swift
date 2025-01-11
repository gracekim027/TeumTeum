//
//  Text+LineHeight.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

extension Text {
    /// `percentage` : 100 if 100%
    func lineHeight(with font: UIFont, percentage: CGFloat) -> some View {
        let roundedSpacing = ((font.pointSize * (percentage - 100) / 100) * 0.5)
        return self
            .font(.init(font))
            .lineSpacing(roundedSpacing.rounded(.up) + 1)
            .padding(.vertical, roundedSpacing.rounded(.down))
    }
}
