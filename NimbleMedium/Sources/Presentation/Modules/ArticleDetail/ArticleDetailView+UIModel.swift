//
//  ArticleDetailView+UIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 22/09/2021.
//

import Foundation

extension ArticleDetailView {

    struct UIModel: Equatable {

        let articleTitle: String
        let articleBody: String
        let articleUpdatedAt: String
        let authorName: String
        let authorImage: URL?
        var authorFollowing: Bool

        init(article: Article) {
            articleTitle = article.title
            articleBody = article.body
            articleUpdatedAt = article.updatedAt.format(with: .monthDayYear)
            authorImage = try? article.author.image?.asURL()
            authorName = article.author.username
            authorFollowing = article.author.following
        }
    }
}
