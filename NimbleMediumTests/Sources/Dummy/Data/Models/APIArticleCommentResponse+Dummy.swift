//
//  APIArticleCommentResponse+Dummy.swift
//  NimbleMediumTests
//
//  Created by Minh Pham on 19/10/2021.
//

@testable import NimbleMedium

extension APIArticleCommentResponse {

    static let dummy: APIArticleCommentResponse = {
        R.file.articleCommentJson.decoded()
    }()
}
