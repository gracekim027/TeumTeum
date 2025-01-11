//
//  Chat.swift
//  piyakton
//
//  Created by 최유림 on 1/12/25.
//

import Foundation

struct Chat: Hashable {
    let received: Bool
    let content: [String]
}

extension Chat {
    static var debug1: Self = .init(received: true,
                                    content: ["칸트의 주요 사상에 대해 이야기해봐요.", "궁금한 점이 있나요?"])
    static var debug2: Self = .init(received: false,
                                    content: ["칸트는 살아생전 어떤 제자를 가르쳤나요?"])
    static var debug3: Self = .init(received: true,
                                    content: ["임마누엘 칸트는 쾨니히스베르크 대학에서 강의를 통해 많은 철학자들에게 영향을 미쳤으며, 그의 사상은 독일 관념론 발전에 중요한 기초가 되었습니다. 칸트의 철학에 깊은 영향을 받은 인물로는 요한 고틀리프 피히테, 카를 레오나르트 라인홀트, 프리드리히 슐레겔, 빌헬름 폰 훔볼트 등이 있습니다. 이들은 칸트의 철학을 계승하거나 비판적으로 수용하며 자신들의 사상을 발전시켰고, 이를 통해 칸트의 영향력은 동시대와 후대에 걸쳐 널리 퍼졌습니다."])
}
