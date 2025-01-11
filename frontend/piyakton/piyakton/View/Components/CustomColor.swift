//
//  CustomColor.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

extension Color {
    static let whiteOpacity100: Color = .white.opacity(0.1)
    static let whiteOpacity700: Color = .white.opacity(0.7)
    static let whiteOpacity800: Color = .white.opacity(0.8)
    
    static let grayOpacity800: Color = .init(red: 37 / 255, green: 34 / 255, blue: 38 / 255, opacity: 0.8)
    
    static let gray400: Color = Color(red: 0.59, green: 0.59, blue: 0.61)
    static let gray50: Color = .init(white: 247 / 255)
    static let gray500: Color = .init(red: 109 / 255, green: 109 / 255, blue: 111 / 255)
    static let gray700: Color = .init(red: 74 / 255, green: 74 / 255, blue: 76 / 255)
    static let gray800: Color = .init(red: 66 / 255, green: 66 / 255, blue: 68 / 255)
    static let gray900: Color = .init(red: 45 / 255, green: 45 / 255, blue: 46 / 255)
    
    static let red500: Color = .init(red: 235 / 255, green: 59 / 255, blue: 59 / 255)
    static let coral600: Color = .init(red: 245 / 255, green: 97 / 255, blue: 28 / 255)
    static let orange600: Color = .init(red: 255 / 255, green: 145 / 255, blue: 20 / 255)
    static let lime600: Color = .init(red: 221 / 255, green: 247 / 255, blue: 29 / 255)
}
