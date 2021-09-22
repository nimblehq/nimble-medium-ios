//  swiftlint:disable:this file_name
//
//  FeedDetailUIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 22/09/2021.
//

import Foundation

extension FeedDetailView {

    struct UIModel: Equatable {

        let articleTitle: String
        let articleBody: String
        let articleUpdatedAt: String
        let authorName: String
        let authorImage: URL?

        init(article: Article) {
            articleTitle = article.title
            articleBody = article.body
            articleUpdatedAt = article.updatedAt.format(with: .monthDayYear)
            authorImage = try? article.author.image?.asURL()
            authorName = article.author.username
        }
    }
}
