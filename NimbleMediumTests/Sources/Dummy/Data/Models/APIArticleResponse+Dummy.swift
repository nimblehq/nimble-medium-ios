//
//  APIArticleResponse.swift
//  NimbleMediumTests
//
//  Created by Mark G on 08/09/2021.
//

@testable import NimbleMedium

extension APIArticleResponse {

    static let dummy: APIArticleResponse = {
        """
        {
            "articlesCount" : 1,
            "articles" : [
            {
            "slug" : "Welcome-to-RealWorld-project",
            "tagList" : [
            "introduction",
            "welcome"
            ],
            "author" : {
            "bio" : null,
            "username" : "Gerome",
            "image" : "https://realworld-temp-api.herokuapp.com/images/demo-avatar.png"
            },
            "comments" : [

            ],
            "favoritesCount" : 1,
            "title" : "Welcome to RealWorld project",
            "favorited" : false,
            "updatedAt" : "2021-09-05T22:23:59.819Z",
            "description" : "Exemplary fullstack Medium.com clone powered by React, Angular, Node, Django, and many more",
            "body" : "See how the exact same Medium.com clone (called Conduit) is built using different frontends and backends. Yes, you can mix and match them, because they all adhere to the same API spec",
            "createdAt" : "2021-09-05T22:23:59.819Z"
            }
            ]
        }
        """
            .utf8Data
            .decoded()
    }()
}
