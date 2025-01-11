//
//  TaskRepository.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore

class TaskRepository {
    private let db = Firestore.firestore()
    private let userCollection = "users"
    private let user = "test"
    private let taskCollection = "tasks"
    
    func createTask(description: String, unitTime: Int, fileInfo: UploadedFile) async throws -> String {
        let taskData: [String: Any] = [
            "description": description,
            "unitTime": unitTime,
            "done": false,
            "fileInfo": [
                "id": fileInfo.id,
                "name": fileInfo.name,
                "type": fileInfo.type.rawValue,
                "url": fileInfo.url
            ],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        let docRef = try await db.collection(userCollection)
                                .document(user)
                                .collection(taskCollection)
                                .addDocument(data: taskData)
        
        return docRef.documentID
    }
    
    func observeTask(taskId: String, completion: @escaping (MainTask?) -> Void) {
        db.collection(userCollection)
            .document(user)
            .collection(taskCollection)
            .document(taskId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot,
                      let data = document.data() else {
                    print("Error fetching task: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                
                // Convert the dictionary data to your Task model
                let task = MainTask(
                    id: taskId,
                    description: data["description"] as? String ?? "",
                    unitTime: data["unitTime"] as? Int ?? 0,
                    done: data["done"] as? Bool ?? false,
                    fileInfo: self.convertToUploadedFile(from: data["fileInfo"] as? [String: Any] ?? [:]),
                    title: data["title"] as? String,
                    summary: data["summary"] as? String,
                    totalTime: data["totalTime"] as? Int,
                    subtasks: self.convertToSubtasks(from: data["subtasks"] as? [[String: Any]] ?? [])
                )
                
                completion(task)
            }
    }
    
    private func convertToUploadedFile(from dict: [String: Any]) -> UploadedFile {
        let fileId = dict["id"] as? String ?? ""
        let fileName = dict["name"] as? String ?? ""
        let fileType = FileType(rawValue: dict["type"] as? String ?? "pdf") ?? .pdf
        let urlString = dict["url"] as? String ?? ""
        let url = URL(string: urlString) ?? URL(string: "about:blank")!
        
        return UploadedFile(id: fileId, name: fileName, type: fileType, url: url)
    }
    
    private func convertToSubtasks(from array: [[String: Any]]) -> [Subtask]? {
        let subtasks = array.map { dict in
            Subtask(
                title: dict["title"] as? String ?? "",
                summary: dict["summary"] as? String ?? "",
                order: dict["order"] as? Int ?? 0,
                content: dict["content"] as? String ?? "",
                done: dict["done"] as? Bool ?? false
            )
        }
        return subtasks.isEmpty ? nil : subtasks
    }
}
