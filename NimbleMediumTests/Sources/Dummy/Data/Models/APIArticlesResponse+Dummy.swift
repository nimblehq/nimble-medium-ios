//
//  APIArticlesResponse.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

@testable import NimbleMedium

extension APIArticlesResponse {

    static let dummy: APIArticlesResponse = {
        R.file.articlesJson.decoded()
    }()
}
