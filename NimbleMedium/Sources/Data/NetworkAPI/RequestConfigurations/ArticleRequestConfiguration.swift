//
//  ArticleRequestConfiguration.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import Alamofire

enum ArticleRequestConfiguration {

    case createArticle(params: CreateArticleParameters)
    case deleteArticle(slug: String)
    case listArticles(params: GetArticlesParameters)
    case getArticle(slug: String)
}

extension ArticleRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .createArticle, .listArticles:
            return "/articles"
        case .deleteArticle(let slug), .getArticle(let slug):
            return "articles/\(slug)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createArticle:
            return .post
        case .deleteArticle:
            return .delete
        case .listArticles, .getArticle:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createArticle(let params):
            return ["article": params.dictionary]
        case .listArticles(let params):
            return params.dictionary.compactMapValues { $0 }
        case .deleteArticle, .getArticle:
            return nil
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createArticle:
            return URLEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
}
