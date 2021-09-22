//  swiftlint:disable:this file_name
//
//  FeedRowUIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 21/09/2021.
//

import Foundation

extension FeedRow {

    struct UIModel: Equatable {

        let id: String
        let articleTitle: String
        let articleDescription: String
        let articleUpdatedAt: String
        let authorImage: URL?
        let authorName: String

        init(article: Article) {
            id = article.id
            articleTitle = article.title
            articleDescription = article.description
            articleUpdatedAt = article.updatedAt.format(with: .monthDayYear)
            authorImage = try? article.author.image?.asURL()
            authorName = article.author.username
        }
    }
}
