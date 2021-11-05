//
//  ArticleCommentRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Alamofire

enum ArticleCommentRequestConfiguration {

    case createComment(slug: String, body: String)
    case deleteComment(slug: String, id: String)
    case getComments(slug: String)
}

extension ArticleCommentRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case let .createComment(slug, _), let .getComments(slug):
            return "/articles/\(slug)/comments"
        case let .deleteComment(slug, id):
            return "/articles/\(slug)/comments/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createComment:
            return .post
        case .deleteComment:
            return .delete
        case .getComments:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .createComment(_, body):
            return ["comment": ["body": body]]
        case .deleteComment, .getComments:
            return [:]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createComment, .deleteComment:
            return URLEncoding.default
        case .getComments:
            return URLEncoding.queryString
        }
    }
}
