//
//  CustomBlur.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import Foundation

enum CustomBlur {
    case weak
    case normal
    case medium
    case strong
    
    var radius: CGFloat {
        switch self {
        case .weak: 4
        case .normal: 8
        case .medium: 16
        case .strong: 24
        }
    }
}
