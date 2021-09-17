//
//  ArticleCommentRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Alamofire

enum ArticleCommentRequestConfiguration {

    case getComments(slug: String)
}

extension ArticleCommentRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .getComments(let slug):
            return "/articles/\(slug)/comments"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getComments:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getComments:
            return [:]
        }
    }

    var encoding: ParameterEncoding { URLEncoding.queryString }
}
