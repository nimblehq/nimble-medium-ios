//
//  ArticleRepository.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

final class ArticleRepository: ArticleRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol

    init(networkAPI: NetworkAPIProtocol) {
        self.networkAPI = networkAPI
    }

    func listArticles(
        tag: String?,
        author: String?,
        favorited: String?,
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]> {
        let requestConfiguration = ArticleRequestConfiguration.listArticles(
            tag: tag,
            author: author,
            favorited: favorited,
            limit: limit,
            offset: offset
        )

        return networkAPI
            .performRequest(requestConfiguration, for: APIArticlesResponse.self)
            .map { $0.articles.map { $0 as Article } }
    }

    func getArticle(slug: String) -> Single<Article> {
        let requestConfiguration = ArticleRequestConfiguration
            .getArticle(slug: slug)

        return networkAPI
            .performRequest(requestConfiguration, for: APIArticleResponse.self)
            .map { $0.article as Article }
    }
}
