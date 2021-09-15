//
//  APIArticleResponse+Dummy.swift
//  NimbleMediumTests
//
//  Created by Mark G on 14/09/2021.
//

@testable import NimbleMedium

extension APIArticleResponse {

    static let dummy: APIArticleResponse = {
        R.file.singleArticleJson.decoded()
    }()
}
