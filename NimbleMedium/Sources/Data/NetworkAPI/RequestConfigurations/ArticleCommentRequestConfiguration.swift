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
        case .createComment(let slug, _), .getComments(let slug):
            return "/articles/\(slug)/comments"
        case .deleteComment(let slug, let id):
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
        case .createComment(_, let body):
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
