//
//  TaskCardView.swift
//  TeumTeum
//
//  Created by 최유림 on 1/11/25.
//

import SwiftUI

struct TaskCardView: View {
    
    @State var todoGroup: TodoGroup
    let mode: Mode
    
    init(todoGroup: TodoGroup, mode: Mode) {
        _todoGroup = .init(initialValue: todoGroup)
        self.mode = mode
    }
    
    @State private var isExpanded: Bool = false
    @State private var selected: Article?
    @State private var showDetailView: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                headerSection()
                
                if mode == .normal || isExpanded,
                   let articleList = todoGroup.articleList {
    //                List(articleList, id: \.id) { article in
    //                    NavigationLink {
    //                        ArticleDetailView(todoGroup: todoGroup, selected: 0)
    //                    } label: {
    //                        ArticlePreviewCell(article: article)
    //                    }
    //                }
                    VStack(spacing: 8) {
                        ForEach(articleList, id: \.id) { article in
                            ArticlePreviewCell(article: article)
                                .onTapGesture {
                                    showDetailView = true
                                }
    //                        NavigationLink {
    //                            ArticleDetailView(todoGroup: todoGroup, selected: 0)
    //                        } label: {
    //                            ArticlePreviewCell(article: article)
    //                        }
                        }
                    }
                    .padding(.bottom, 20)
                    .geometryGroup()
                }
            }
            .geometryGroup()
            .transition(.asymmetric(insertion: .push(from: .top).combined(with: .opacity),
                                    removal: .move(edge: .bottom).combined(with: .opacity)))
            
            if mode == .expandable {
                CustomDivider()
            }
        }
        .sheet(isPresented: $showDetailView) {
            ArticleDetailView(todoGroup: todoGroup, selected: 0)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

extension TaskCardView {
    @ViewBuilder private func headerSection() -> some View {
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
                withAnimation(.smooth(duration: 0.45)) {
                    isExpanded.toggle()
                }
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
