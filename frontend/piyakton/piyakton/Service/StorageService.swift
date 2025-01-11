//
//  StorageService.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseStorage

class StorageService {
    private let storage = Storage.storage().reference()
    
    func uploadFile(url: URL, type: FileType) async throws -> URL {
        let fileName = "\(UUID().uuidString)_\(url.lastPathComponent)"
        let fileRef = storage.child("files/\(type)/\(fileName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = type == .pdf ? "application/pdf" : "audio/mpeg"

        let _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, Error>) in
                    fileRef.putFile(from: url, metadata: metadata) { metadata, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        
                        if let metadata = metadata {
                            continuation.resume(returning: metadata)
                        } else {
                            continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload file"]))
                        }
                    }
                }
        
        return try await fileRef.downloadURL()
    }
}
