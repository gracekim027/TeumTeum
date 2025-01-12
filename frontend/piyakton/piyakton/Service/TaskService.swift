//
//  TaskService.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore

import SwiftUI

class TaskService {
    private let repository: TaskRepository
    private let storageService: StorageService
    
    init(repository: TaskRepository,
         storageService: StorageService = StorageService()) {
        self.repository = repository
        self.storageService = storageService
    }
    
    func createTask(description: String, unitTime: Int, fileInfo: UploadedFile) async throws -> String {
        print("[TaskService] created task")
    
        do {
            guard let originalURL = fileInfo.getURL() else {
                throw NSError(domain: "TaskService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            }
            
            let downloadURL = try await storageService.uploadFile(url: originalURL, type: fileInfo.type)
            
            // Create a new UploadedFile with the Firebase Storage URL
            var storedFile = fileInfo
            storedFile.url = downloadURL.absoluteString
            
            let taskId = try await repository.createTask(
                description: description,
                unitTime: unitTime,
                fileInfo: storedFile
            )
            
            return taskId
            
        } catch {
            print("[TaskService] Error in createTask method:")
            print("  Error: \(error.localizedDescription)")
            throw error
        }
    }
}
