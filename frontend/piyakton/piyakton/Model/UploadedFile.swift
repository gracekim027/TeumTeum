//
//  UploadedFile.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

enum FileType: String, Codable {
    case pdf
    case mp3
}

struct UploadedFile: Identifiable, Codable {
    let id: String
    let name: String
    var detail: String? = nil
    let type: FileType
    let url: URL
    
    init(id: String = UUID().uuidString, name: String, type: FileType, url: URL) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }
}

extension UploadedFile {
    static var debug: Self = .init(name: "한국현대사의 이해",
                                   type: .pdf,
                                   url: URL(string: "example")!)
}

enum FileState {
    case uploading
    case waiting
}
