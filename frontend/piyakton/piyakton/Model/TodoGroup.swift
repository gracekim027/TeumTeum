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
    static var debug1: Self = .init(id: "\(Int.random(in: 0...100))", description: "설명", unitTime: .long, completed: false, fileInfo: .debug, title: "철학개론", articleList: [.debug3])
    static var debug2: Self = .init(id: "\(Int.random(in: 0...100))", description: "설명", unitTime: .long, completed: false, fileInfo: .debug, title: "철학개론", articleList: [.debug3, .debug3])
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

struct Article: Codable {
    let id: String
    let title: String
    let summary: String
    let order: Int
    let content: [Content]
    var done: Bool
}

struct Content: Identifiable, Codable {
    var id = UUID()
    let title: String
    let body: String
}

extension Article {
//    static var debug1: Self = .init(id: "\(Int.random(in: 0...100))", title: "소크라테스 \"너 자신을 알라\"", summary: "아무거나", order: 1, content: "매우 긴 내용", done: false)
//    static var debug2: Self = .init(id: "\(Int.random(in: 0...100))", title: "이상주의 철학의 선구자 플라톤", summary: "아무거나", order: 2, content: "매우 긴 내용", done: true)
    static var debug3: Self = .init(id: "\(Int.random(in: 0...100))", title: "이상주의 철학의 선구자 플라톤", summary: "아무거나", order: 3, content: [
        .init(title: "Direct Access Array란?", body: "Direct Access Array는 키 값을 배열의 인덱스로 직접 사용하는 단순하면서도 강력한 자료구조입니다. 예를 들어, 학번을 키로 사용한다면 학번이 곧바로 배열의 위치가 되어 즉시 데이터에 접근할 수 있죠. 마치 아파트에서 호수를 보고 바로 찾아가는 것처럼요."),
        .init(title: "Direct Access Array의 장점", body: "가장 큰 장점은 검색 속도입니다. 원하는 데이터를 찾을 때 비교 연산이 전혀 필요 없이 한 번에 접근할 수 있어 O(1) 시간이 걸립니다. 또한 구현이 매우 간단하고 직관적이어서 코드를 이해하기 쉽습니다. 삽입과 삭제 연산도 마찬가지로 O(1) 시간에 가능하죠."),
        .init(title: "Direct Access Array의 한계", body: "하지만 심각한 단점이 있습니다. 키 값의 범위만큼 배열 공간이 필요하기 때문에 메모리 낭비가 심각할 수 있습니다. 예를 들어 주민등록번호를 키로 사용한다면, 실제 저장할 데이터는 몇 개 없더라도 수억 개의 공간을 미리 확보해야 합니다. 또한 문자열이나 실수처럼 연속적이지 않은 키는 직접 사용할 수 없다는 제약도 있습니다. 이러한 한계를 극복하기 위해 해시 테이블이 등장하게 되었죠.")
    ], done: true)
}
