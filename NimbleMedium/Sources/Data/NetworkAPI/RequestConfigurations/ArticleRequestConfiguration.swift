//
//  ArticleRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Alamofire

enum ArticleRequestConfiguration {

    case listArticles(
            tag: String?,
            author: String?,
            favorited: String?,
            limit: Int?,
            offset: Int?
         )
    case getArticle(slug: String)
}

extension ArticleRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .listArticles:
            return "/articles"
        case .getArticle(let slug):
            return "articles/\(slug)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listArticles, .getArticle:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .listArticles(
                let tag,
                let author,
                let favorited,
                let limit,
                let offset
        ):
            let parameters: [String: Any?] = [
                "tag": tag,
                "author": author,
                "favorited": favorited,
                "limit": limit,
                "offset": offset
            ]
            return parameters.compactMapValues { $0 }
        case .getArticle:
            return [:]
        }
    }

    var encoding: ParameterEncoding { URLEncoding.queryString }
}
