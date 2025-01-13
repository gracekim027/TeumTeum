//
//  Task.swift
//  TeumTeum
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
    static var debug1: Self = .init(id: "\(Int.random(in: 0...100))", description: "설명", unitTime: .long, completed: false, fileInfo: file, title: "철학개론", articleList: [.debug3])
}

extension TodoGroup {
    static var file = UploadedFile(
        name: "hashing_pdf.pdf",
        type: .pdf,
        url: "https://example.com/hashing_pdf.pdf"
    )
    
    static var dummyData: Self = .init(
        id: "6be8602e-6164-4f1a-b385-a22348fa5f12",
        description: "어제 교수님이 수업시간에 다룬 것에 대한 간단한 복습. 차후 과제에 대비하기 위한 용.",
        unitTime: .medium,
        completed: false,
        fileInfo: file,
        title: "해싱에 대한 소개",
        summary: "This material from \"6.006 Introduction to Algorithms: Lecture 4\" focuses on the fundamental concepts of hashing, providing a thorough exploration of its key components and principles. The lecture begins by addressing the limitations of comparison-based search algorithms, emphasizing the necessity for more efficient data structures. Key topics include:",
        totalTime: 45,
        articleList: [
            Article(
                id: "60ac2403-b640-4aa7-8c28-98511b2949e7",
                title: "해싱 알고리즘의 기본 개념 이해하기",
                summary: "해싱은 데이터를 빠르게 검색하기 위한 핵심 기술입니다. 비교 기반 검색의 한계를 극복하고 효율적인 데이터 접근을 가능하게 하는 방법을 알아봅시다.",
                order: 1,
                content: [
                    Content(
                        title: "해싱이 필요한 이유",
                        body: "일반적인 검색 방법은 데이터를 하나씩 비교해가며 찾아야 해서 시간이 많이 걸립니다. 예를 들어, 도서관에서 책을 찾을 때 책장을 처음부터 끝까지 살펴보는 것과 같죠. 해싱은 이런 비효율적인 검색 방식을 획기적으로 개선할 수 있는 방법입니다."
                    ),
                    Content(
                        title: "해시 함수의 역할",
                        body: "해시 함수는 우리가 찾으려는 데이터를 특정 위치와 연결시켜주는 특별한 함수입니다. 마치 도서관에서 책의 위치를 알려주는 청구기호와 비슷하죠. 입력값이 주어지면 해시 함수는 이를 고유한 위치값으로 변환해서, 나중에 그 데이터를 빠르게 찾을 수 있게 해줍니다."
                    ),
                    Content(
                        title: "실생활 속의 해싱",
                        body: "우리 주변에서도 해싱의 예를 쉽게 찾을 수 있습니다. 학생증 번호로 사물함을 배정받거나, 주민등록번호로 신분을 확인하는 것도 일종의 해싱입니다. 이처럼 해싱은 복잡한 정보를 단순화하고 빠르게 접근할 수 있게 만들어주는 실용적인 도구입니다."
                    )
                ],
                done: false
            ),
            Article(
                id: "cd08d21e-39e0-483f-b707-f9c8982cd031",
                title: "단순 검색의 한계: 실생활 예시로 이해하기",
                summary: "단순 검색(Simple Search)의 한계점을 실생활 예시를 통해 알아봅니다. 왜 해싱과 같은 고급 검색 방법이 필요한지 이해할 수 있습니다.",
                order: 2,
                content: [
                    Content(
                        title: "도서관에서 책 찾기 예시",
                        body: "여러분, 도서관에서 책을 찾아본 경험이 있으시죠? 만약 도서관에 책이 무작위로 배열되어 있다면 어떨까요? 원하는 책을 찾기 위해 한 권씩 확인해야 할 것입니다. 이것이 바로 단순 검색의 대표적인 예시입니다. n개의 책이 있다면, 최악의 경우 n번을 찾아야 하죠."
                    ),
                    Content(
                        title: "전화번호부 검색 비교",
                        body: "반면 전화번호부는 가나다순으로 정렬되어 있어서 훨씬 빠르게 찾을 수 있습니다. 하지만 여기에도 한계가 있어요. 새로운 번호를 중간에 삽입하려면 많은 페이지를 이동시켜야 하고, 수정이 번거롭죠. 이는 정렬된 배열에서의 검색이 가진 한계를 보여줍니다."
                    ),
                    Content(
                        title: "실생활에서 느끼는 단순 검색의 문제점",
                        body: "여러분의 책상 서랍을 생각해보세요. 물건이 무작위로 있다면 원하는 것을 찾기 위해 하나씩 확인해야 합니다. 이는 시간이 많이 걸리고 비효율적이죠. 이러한 불편함이 바로 단순 검색의 한계입니다. 이런 문제를 해결하기 위해 우리는 더 효율적인 방법, 즉 해싱과 같은 고급 검색 방법이 필요한 것입니다."
                    )
                ],
                done: false
            ),
            Article(
                id: "e043dc72-e9df-43e1-b1e3-c80945f3af87",
                title: "해시 함수의 기본 목적과 특징 이해하기",
                summary: "해시 함수는 데이터를 효율적으로 저장하고 검색하기 위한 핵심 도구입니다. 이 내용에서는 해시 함수의 기본적인 목적과 주요 특징을 알아봅니다.",
                order: 3,
                content: [
                    Content(
                        title: "해시 함수란 무엇일까요?",
                        body: "해시 함수는 임의의 크기를 가진 데이터를 고정된 크기의 값으로 변환하는 특별한 함수예요. 마치 도서관에서 책을 특정 위치에 배정하는 것처럼, 데이터를 저장할 위치를 결정해주는 역할을 합니다. 예를 들어, 긴 문자열이나 파일을 간단한 숫자로 바꿔주는 거죠."
                    ),
                    Content(
                        title: "해시 함수의 주요 목적",
                        body: "해시 함수의 가장 중요한 목적은 데이터를 빠르게 찾을 수 있게 하는 거예요. 일일이 처음부터 끝까지 찾아보는 것보다, 해시 값을 이용하면 원하는 데이터가 있는 위치를 바로 알 수 있죠. 마치 책의 목차나 색인을 보고 원하는 페이지를 바로 찾아가는 것과 비슷해요."
                    ),
                    Content(
                        title: "좋은 해시 함수의 조건",
                        body: "좋은 해시 함수는 몇 가지 중요한 특징을 가지고 있어요. 첫째, 같은 입력에는 항상 같은 해시 값을 만들어내야 해요. 둘째, 서로 다른 입력값들이 최대한 다른 해시 값을 가지도록 해야 해요. 이를 통해 데이터가 고르게 분포되고, 충돌이 적게 발생하게 되죠. 마지막으로, 계산 속도가 빨라야 해요."
                    )
                ],
                done: false
            ),
            Article(
                id: "1ec36cad-07f5-47fe-a92a-9fbbcd4c6f06",
                title: "해시 함수의 입력과 출력 관계 이해하기",
                summary: "해시 함수가 어떻게 입력값을 출력값으로 변환하는지 실제 예시를 통해 알아봅니다. 일상생활에서 볼 수 있는 비유를 통해 해시 함수의 동작 원리를 쉽게 이해해봅시다.",
                order: 4,
                content: [
                    Content(
                        title: "해시 함수란?",
                        body: "해시 함수는 마치 요리 레시피처럼 작동합니다. 재료(입력값)가 들어가면 정해진 과정을 거쳐 항상 같은 요리(출력값)가 나오죠. 예를 들어, 여러분의 주민등록번호를 해시 함수에 넣으면 항상 동일한 특정 숫자가 나오는 것처럼요."
                    ),
                    Content(
                        title: "실제 예시로 보는 해시 변환",
                        body: "간단한 해시 함수를 상상해볼까요? 문자열의 각 글자를 숫자로 바꾸고 모두 더한 다음, 10으로 나눈 나머지를 구한다고 해봅시다. \"안녕\"이라는 입력값이 들어오면, '안'은 1, '녕'은 2로 계산해서 1+2=3이 되고, 이것을 10으로 나누면 나머지 3이 최종 해시값이 되는 거죠. 이런 방식으로 어떤 길이의 입력값이 들어와도 0부터 9 사이의 값이 나오게 됩니다."
                    ),
                    Content(
                        title: "해시 충돌 이해하기",
                        body: "하지만 여기서 재미있는 현상이 발생합니다. \"안녕\"과 \"안녕하세요\"를 같은 방식으로 계산했을 때 우연히 같은 값이 나올 수 있어요. 이것을 해시 충돌이라고 부르는데, 마치 다른 재료로 비슷한 맛의 요리가 나오는 것과 같습니다. 이런 충돌을 해결하는 방법은 다음 시간에 자세히 알아보도록 하겠습니다."
                    )
                ],
                done: false
            ),
            Article(
                id: "0b21ec7a-172d-4c90-ad5d-91d84a2cbb6d",
                title: "주요 해시 함수의 종류와 활용",
                summary: "컴퓨터 과학에서 자주 사용되는 해시 함수들의 특징과 용도를 알아봅니다. 실제 응용 사례를 통해 각 해시 함수의 장단점을 이해할 수 있습니다.",
                order: 5,
                content: [
                    Content(
                        title: "기본 해시 함수의 이해",
                        body: "해시 함수는 임의의 크기를 가진 데이터를 고정된 크기의 값으로 변환하는 함수예요. 가장 기본적인 해시 함수로는 나눗셈 방법이 있는데, 입력값을 테이블 크기로 나눈 나머지를 사용합니다. 예를 들어, 테이블 크기가 7이고 입력값이 22라면, 22를 7로 나눈 나머지인 1이 해시값이 되죠."
                    ),
                    Content(
                        title: "문자열을 위한 해시 함수",
                        body: "문자열을 해시할 때는 주로 다항식 해시 함수를 사용해요. 각 문자를 숫자로 변환하고, 위치에 따른 가중치를 곱한 다음 모두 더하는 방식이에요. 예를 들어 \"cat\"이란 단어는 각 문자를 아스키 값으로 변환한 후, 특정 기수(보통 31이나 33)의 거듭제곱을 곱해서 계산합니다. 이 방법은 문자열의 순서도 고려할 수 있어서 효과적이에요."
                    ),
                    Content(
                        title: "암호학적 해시 함수",
                        body: "보안이 중요한 상황에서는 MD5, SHA-1, SHA-256같은 암호학적 해시 함수를 사용해요. 이런 함수들은 입력값이 조금만 달라져도 완전히 다른 해시값을 만들어내고, 역으로 해시값에서 원래 입력을 찾아내기가 거의 불가능해요. 비밀번호 저장이나 디지털 서명에 주로 사용되는데, 최근에는 SHA-256이 가장 널리 사용되고 있답니다."
                    )
                    ],
                    done: false
                            ),
                            Article(
                                id: "bbbd1e89-e274-430f-9c77-0d8c717f871c",
                                title: "해시 테이블의 핵심 구성 요소 이해하기",
                                summary: "해시 테이블의 기본 구조와 핵심 구성 요소를 쉽게 설명합니다. 5분 안에 해시 테이블의 기초를 완벽하게 이해할 수 있습니다.",
                                order: 6,
                                content: [
                                    Content(
                                        title: "해시 테이블이란?",
                                        body: "해시 테이블은 마치 도서관의 책장처럼 데이터를 효율적으로 저장하고 검색할 수 있게 해주는 자료구조예요. 일반적인 배열과 달리, 특별한 방식으로 데이터를 정리해서 원하는 정보를 매우 빠르게 찾을 수 있답니다."
                                    ),
                                    Content(
                                        title: "핵심 구성 요소",
                                        body: "해시 테이블에는 크게 두 가지 중요한 부분이 있어요. 첫 번째는 '해시 함수'로, 데이터를 저장할 위치를 계산해주는 특별한 계산식이에요. 두 번째는 '버킷'이라고 하는 실제 데이터가 저장되는 공간이죠. 마치 우편번호가 편지를 분류하는 것처럼, 해시 함수는 데이터가 어느 버킷에 들어갈지 결정해줍니다."
                                    ),
                                    Content(
                                        title: "작동 방식",
                                        body: "예를 들어, 전화번호부를 만든다고 생각해볼까요? 해시 테이블은 이름을 입력받으면 해시 함수를 통해 특정 번호로 변환해요. 이 번호가 바로 데이터가 저장될 버킷의 주소가 되는 거죠. 나중에 같은 이름을 검색하면, 같은 과정을 거쳐서 바로 그 버킷을 찾아갈 수 있어요. 이런 방식 덕분에 데이터를 아주 빠르게 찾을 수 있답니다."
                                    )
                                ],
                                done: false
                            )
                        ]
                    )
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
    
    var description: String {
        switch self {
        case .short: return "짧은 틈에 빠르게 🐇"
        case .medium: return "적당한 틈에 부담없이 🐈"
        case .long: return "넉넉한 틈에 여유롭게 🐢"
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
