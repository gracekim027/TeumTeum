//
//  TaskRepository.swift
//  TeumTeum
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI
import FirebaseFirestore

class TaskRepository {
    
    private var db: Firestore
    private let userCollection = "users"
    private let user = "test"
    private let taskCollection = "tasks"
    
    init(db: Firestore) {
        self.db = db
    }
    
    func createTask(description: String, unitTime: Int, fileInfo: UploadedFile) async throws -> String {
        let taskData: [String: Any] = [
            "description": description,
            "unit_time": unitTime,
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
        print(docRef)
        return docRef.documentID
    }
    
    func observeTask(taskId: String, completion: @escaping (TodoGroup?) -> Void) {
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
                let todo = TodoGroup(
                    id: taskId,
                    description: data["description"] as? String ?? "",
                    unitTime: RequiredTime(rawValue: data["unitTime"] as? Int ?? 0) ?? .short,
                    completed: data["done"] as? Bool ?? false,
                    fileInfo: self.convertToUploadedFile(from: data["fileInfo"] as? [String: Any] ?? [:]),
                    title: data["title"] as? String,
                    summary: data["summary"] as? String,
                    totalTime: data["totalTime"] as? Int,
                    articleList: self.convertToArticleList(from: data["subtasks"] as? [[String: Any]] ?? [])
                )
                
                completion(todo)
            }
    }
    
    func fetchTodoGroup() async throws -> [TodoGroup] {
        return []
    }
    
    private func convertToUploadedFile(from dict: [String: Any]) -> UploadedFile {
        let fileId = dict["id"] as? String ?? ""
        let fileName = dict["name"] as? String ?? ""
        let fileType = FileType(rawValue: dict["type"] as? String ?? "pdf") ?? .pdf
        let urlString = dict["url"] as? String ?? ""
        let url = URL(string: urlString) ?? URL(string: "about:blank")!
        
        return UploadedFile(id: fileId, name: fileName, type: fileType, url: url)
    }
    
    private func convertToArticleList(from array: [[String: Any]]) -> [Article]? {
        let articleList = array.map { dict in
            let contentList = dict["content"] as! [Content]
            return Article(
                id: dict["id"] as? String ?? "",
                title: dict["title"] as? String ?? "",
                summary: dict["summary"] as? String ?? "",
                order: dict["order"] as? Int ?? 0,
                content: contentList,
                done: dict["done"] as? Bool ?? false
            )
        }
        return articleList.isEmpty ? nil : articleList
    }
}
