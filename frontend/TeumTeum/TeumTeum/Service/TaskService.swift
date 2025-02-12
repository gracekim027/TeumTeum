//
//  TaskService.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import FirebaseFirestore
import SwiftUI

final class TaskService {
    private let repository: TaskRepository
    private let storageService: StorageService
    
    @Published var queuedFileList: [[UploadedFile]] = []
    
    init(repository: TaskRepository, storageService: StorageService) {
        self.repository = repository
        self.storageService = storageService
    }
    
    func appendQueuedFileList(_ fileList: [UploadedFile]) {
        queuedFileList.append(fileList)
    }
    
    func createTask(description: String, unitTime: Int, fileInfo: UploadedFile) async throws -> String {
        print("[TaskService] created task")
        do {
            guard let originalURL = fileInfo.getURL() else { return "" }
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
    
    func fetchTodoGroup() async throws -> [TodoGroup] {
        let todoGroup = try await repository.fetchTodoGroup()
        return todoGroup
    }
}
