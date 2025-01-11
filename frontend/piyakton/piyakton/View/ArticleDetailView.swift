//
//  ArticleDetailView.swift
//  piyakton
//
//  Created by 최유림 on 1/12/25.
//

import SwiftUI

struct ArticleDetailView: View {
    
    let article: Article
    
    var body: some View {
        Text(article.content)
    }
}
