//
//  Task.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct TodoGroup: Identifiable, Codable {
    let id: String?
    let description: String // 사용자 넣은 설명
    let unitTime: RequiredTime // 사용자가 한 subtask 당 할당한 시간
    let completed: Bool // 완료 여부 (default: False)
    let fileInfo: UploadedFile
    
    // Fields added by the backend
    var title: String?
    var summary: String?
    var totalTime: Int?
    var articleList: [Article]?
    
    var doneCount: Int {
        articleList?.count { $0.done } ?? 0
    }
}

extension TodoGroup {
    static var debug1: Self = .init(id: "\(Int.random(in: 0...100))", description: "설명", unitTime: .long, completed: false, fileInfo: .debug, title: "철학개론", articleList: [.debug1])
    static var debug2: Self = .init(id: "\(Int.random(in: 0...100))", description: "설명", unitTime: .long, completed: false, fileInfo: .debug, title: "철학개론", articleList: [.debug1, .debug2])
}

enum RequiredTime: Int, Codable {
    case short = 3
    case medium = 5
    case long = 10
    
    var chipColor: Color {
        switch self {
        case .short: return Color.lime600
        case .medium: return Color.orange600
        case .long: return Color.coral600
        }
    }
}

struct Article: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let summary: String
    let order: Int
    let content: String
    var done: Bool
}

extension Article {
    static var debug1: Self = .init(id: "\(Int.random(in: 0...100))", title: "소크라테스 \"너 자신을 알라\"", summary: "아무거나", order: 1, content: "매우 긴 내용", done: false)
    static var debug2: Self = .init(id: "\(Int.random(in: 0...100))", title: "이상주의 철학의 선구자 플라톤", summary: "아무거나", order: 2, content: "매우 긴 내용", done: true)
}
