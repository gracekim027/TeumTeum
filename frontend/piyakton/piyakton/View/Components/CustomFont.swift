//
//  CustomFont.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

extension Font {
    static let header1Bold: Font = .custom(InteropFont.bold.name, size: 28)
    static let header2Bold: Font = .custom(InteropFont.bold.name, size: 24)
    static let title2Bold: Font = .custom(InteropFont.bold.name, size: 20)
    static let title3SemiBold: Font = .custom(InteropFont.semiBold.name, size: 18)
    static let body1Regular: Font = .custom(InteropFont.regular.name, size: 16)
    static let body1Medium: Font = .custom(InteropFont.medium.name, size: 16)
    static let body1SemiBold: Font = .custom(InteropFont.semiBold.name, size: 16)
    static let body2Medium: Font = .custom(InteropFont.medium.name, size: 14)
    static let body2SemiBold: Font = .custom(InteropFont.semiBold.name, size: 14)
    static let body2Bold: Font = .custom(InteropFont.bold.name, size: 24)
    static let body3Medium: Font = .custom(InteropFont.medium.name, size: 13)
    static let body3SemiBold: Font = .custom(InteropFont.semiBold.name, size: 18)
    static let caption1Medium: Font = .custom(InteropFont.medium.name, size: 12)
}

enum InteropFont {
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
    case thin
    
    var name: String {
        switch self {
        case .bold:         "Interop-Bold"
        case .extraBold:    "Interop-ExtraBold"
        case .extraLight:   "Interop-ExtraLight"
        case .light:        "Interop-Light"
        case .medium:       "Interop-Medium"
        case .regular:      "Interop-Regular"
        case .semiBold:     "Interop-SemiBold"
        case .thin:         "Interop-Thin"
        }
    }
}
