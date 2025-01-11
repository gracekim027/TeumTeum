//
//  UploadedFile.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct UploadedFile: Identifiable {
    let id = UUID()
    let name: String
    let type: FileType
    let url: URL
}

enum FileType {
    case pdf
    case mp3
}
