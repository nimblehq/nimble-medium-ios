//
//  ArticleRow+UIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 21/09/2021.
//

import Foundation

extension ArticleRow {

    struct UIModel: Equatable {

        let id: String
        let articleTitle: String
        let articleDescription: String
        let articleUpdatedAt: String
        let authorImage: URL?
        let authorName: String
    }
}