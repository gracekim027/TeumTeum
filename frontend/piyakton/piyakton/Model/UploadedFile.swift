//
//  UploadedFile.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct UploadedFile: Identifiable {
    var id = UUID()
    let name: String
    var detail: String? = nil
    let type: FileType
    let url: URL
}

extension UploadedFile {
    static var debug: Self = .init(name: "한국현대사의 이해",
                                   type: .pdf,
                                   url: URL(string: "example")!)
}

enum FileType {
    case pdf
    case mp3
}

enum FileState {
    case uploading
    case waiting
}
