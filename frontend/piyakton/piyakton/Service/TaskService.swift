//
//  TaskService.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

class TaskService {
    private let repository: TaskRepository
    private let storageService: StorageService
    
    init(repository: TaskRepository = TaskRepository(),
         storageService: StorageService = StorageService()) {
        self.repository = repository
        self.storageService = storageService
    }
    
    func createTask(description: String, unitTime: Int, fileInfo: UploadedFile) async throws -> String {
        // Upload the pdf/audio file to Firebase Storage and get the URL
        let downloadURL = try await storageService.uploadFile(url: fileInfo.url, type: fileInfo.type)
        
        // Create new UploadedFile with Firebase Storage URL
        let storedFile = UploadedFile(
            id: fileInfo.id,
            name: fileInfo.name,
            type: fileInfo.type,
            url: downloadURL
        )
    
        return try await repository.createTask(
            description: description,
            unitTime: unitTime,
            fileInfo: storedFile
        )
    }
}
