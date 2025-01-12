//
//  TaskCardView.swift
//  piyakton
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

struct TaskCardView: View {
    
    let todoGroup: TodoGroup
    let mode: Mode
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 6) {
                    RequiredTimeChip(requiredTime: todoGroup.unitTime)
                    
                    if let title = todoGroup.title {
                        Text(title)
                            .font(.title1SemiBold)
                            .foregroundStyle(.white)
                    }
                }
                
                Spacer()
                
                Text("\(todoGroup.doneCount)")
                    .font(.body3Regular)
                    .foregroundStyle(Color.gray50) +
                Text(" / \(todoGroup.articleList?.count ?? 0)개 완료")
                    .font(.body3Regular)
                    .foregroundStyle(Color.gray400)
                
                if mode == .expandable {
                    Image("chevron")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .padding(.vertical, mode == .expandable ? 20 : 16)
            .contentShape(Rectangle())
            .onTapGesture {
                if mode == .expandable {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
            
            if mode == .normal || isExpanded,
               let articleList = todoGroup.articleList {
                VStack {
                    ForEach(articleList, id: \.id) { article in
                        ArticlePreviewCell(article: article)
                    }
                }
                .padding(.bottom, 20)
            }
            
            if mode == .expandable {
                Rectangle()
                    .foregroundStyle(Color.whiteOpacity200)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
            }
        }
    }
}

extension TaskCardView {
    enum Mode {
        case expandable
        case normal
    }
}
