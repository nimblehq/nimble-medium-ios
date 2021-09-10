//
//  APIArticleResponse.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

@testable import NimbleMedium

extension APIArticleResponse {

    static let dummy: APIArticleResponse = {
        R.file.articlesJson.decoded()
    }()
}
