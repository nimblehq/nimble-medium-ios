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
}

extension ArticleRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .listArticles:
            return "/articles"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listArticles:
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
            var parameters = Parameters()

            if let tag = tag {
                parameters["tag"] = tag
            }

            if let author = author {
                parameters["author"] = author
            }

            if let favorited = favorited {
                parameters["favorited"] = favorited
            }

            if let limit = limit {
                parameters["limit"] = limit
            }

            if let offset = offset {
                parameters["offset"] = offset
            }

            return parameters
        }
    }

    var encoding: ParameterEncoding { URLEncoding.queryString }

    var headers: HTTPHeaders? { nil }

    var interceptor: RequestInterceptor? { nil }
}
