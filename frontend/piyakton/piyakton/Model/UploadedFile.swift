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
    let type: FileType
    let url: URL
    
    init(id: String = UUID().uuidString, name: String, type: FileType, url: URL) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }
}
