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
    case favoriteArticle(slug: String)
    case listArticles(params: GetArticlesParameters)
    case getArticle(slug: String)
    case unfavoriteArticle(slug: String)
    case updateArticle(slug: String, params: UpdateMyArticleParameters)
}

extension ArticleRequestConfiguration: RequestConfiguration {

    var baseURL: String { Constants.API.baseURL }

    var endpoint: String {
        switch self {
        case .createArticle, .listArticles:
            return "/articles"
        case .favoriteArticle(let slug), .unfavoriteArticle(let slug):
            return "articles/\(slug)/favorite"
        case .deleteArticle(let slug), .getArticle(let slug), .updateArticle(let slug, _):
            return "articles/\(slug)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createArticle, .favoriteArticle:
            return .post
        case .deleteArticle, .unfavoriteArticle:
            return .delete
        case .getArticle, .listArticles:
            return .get
        case .updateArticle:
            return .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case let .createArticle(params):
            return ["article": params.dictionary]
        case .deleteArticle, .favoriteArticle, .getArticle, .unfavoriteArticle:
            return nil
        case .listArticles(let params):
            return params.dictionary.compactMapValues { $0 }
        case .updateArticle(_, let params):
            let finalParams = params.dictionary.compactMapValues { $0 }
            return ["article": finalParams]
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .createArticle, .updateArticle:
            return URLEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
}
