//
//  UploadedFile.swift
//  TeumTeum
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
    
    var url: String
    
    init(id: String = UUID().uuidString, name: String, type: FileType, url: URL) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url.absoluteString
    }
    
    init(id: String = UUID().uuidString, name: String, type: FileType, url: String) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }
    
    func getURL() -> URL? {
        return URL(string: url)
    }
}

enum FileState {
    case uploading
    case waiting
}
