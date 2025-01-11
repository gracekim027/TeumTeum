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
        
        do {
            _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StorageMetadata, Error>) in
                // Convert URL to Data
                guard let data = try? Data(contentsOf: url) else {
                    print("[StorageService] Failed to convert URL to Data")
                    continuation.resume(throwing: NSError(domain: "StorageService",
                                                         code: -1,
                                                         userInfo: [NSLocalizedDescriptionKey: "Failed to read file data"]))
                    return
                }
                
                fileRef.putData(data, metadata: metadata) { metadata, error in
                    
                    if let error = error {
                        print("[StorageService] Upload error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    if let metadata = metadata {
                        continuation.resume(returning: metadata)
                    } else {
                        let unexpectedError = NSError(domain: "StorageService",
                                                      code: -1,
                                                      userInfo: [NSLocalizedDescriptionKey: "Failed to upload file"])
                        continuation.resume(throwing: unexpectedError)
                    }
                }
            }
            
            let downloadURL = try await fileRef.downloadURL()
            return downloadURL
            
        } catch {
            throw error
        }
    }
}
