//
//  ArticleCommentRow+UIModel.swift
//  NimbleMedium
//
//  Created by Mark G on 23/09/2021.
//

import Foundation

extension ArticleCommentRow {

    struct UIModel: Equatable {

        let commentBody: String
        let commentUpdatedAt: String
        let authorName: String
        let authorImage: URL?
    }
}
