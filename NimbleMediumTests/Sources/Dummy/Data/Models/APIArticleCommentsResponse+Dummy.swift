//
//  APIArticleCommentsResponse+Dummy.swift
//  NimbleMediumTests
//
//  Created by Mark G on 15/09/2021.
//

@testable import NimbleMedium

extension APIArticleCommentsResponse {

    static let dummy: APIArticleCommentsResponse = {
        R.file.articleCommentsJson.decoded()
    }()
}
