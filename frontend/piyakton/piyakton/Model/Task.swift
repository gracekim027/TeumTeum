//
//  Task.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

struct Task: Codable {
    let id: String?
    let description: String // 사용자 넣은 설명
    let unitTime: Int // 사용자가 한 subtask 당 할당한 시간
    let done: Bool // 완료 여부 (default: False)
    let fileInfo: UploadedFile
    
    // Fields added by the backend
    var title: String?
    var summary: String?
    var totalTime: Int?
    var subtasks: [Subtask]?
}

struct Subtask: Codable {
    let title: String
    let summary: String
    let order: Int
    let content: String
    let done: Bool
}
