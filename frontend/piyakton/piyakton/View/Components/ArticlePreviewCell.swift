//
//  ArticlePreviewCell.swift
//  piyakton
//
//  Created by 최유림 on 1/12/25.
//

import SwiftUI

struct ArticlePreviewCell: View {
    
    @State var article: Article
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(article.order)")
                .font(.body3Bold)
                .foregroundStyle(Color.whiteOpacity700)
            
            Text(article.title)
                .font(article.done ? .body1Regular : .body1Medium)
                .foregroundStyle(article.done ? Color.gray600 : .white)
                .strikethrough(article.done)
            
            Spacer()
            
            Button {
                article.done.toggle()
            } label: {
                Image(article.done ? "check-done" : "check-not-done")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(16)
        .background(Color.gray900)
        .contentShape(Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
