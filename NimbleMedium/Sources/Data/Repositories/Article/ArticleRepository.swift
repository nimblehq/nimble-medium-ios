//
//  ArticleRepository.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

final class ArticleRepository: ArticleRepositoryProtocol {

    private let authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol
    private let networkAPI: NetworkAPIProtocol

    init(
        authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol,
        networkAPI: NetworkAPIProtocol
    ) {
        self.authenticatedNetworkAPI = authenticatedNetworkAPI
        self.networkAPI = networkAPI
    }

    func createArticle(params: CreateArticleParameters) -> Single<Article> {
        let requestConfiguration = ArticleRequestConfiguration.createArticle(params: params)

        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIArticleResponse.self)
            .map { $0.article as Article }
    }

    func deleteArticle(slug: String) -> Completable {
        let requestConfiguration = ArticleRequestConfiguration.deleteArticle(slug: slug)
        return authenticatedNetworkAPI.performRequest(requestConfiguration)
    }

    func listArticles(params: GetArticlesParameters) -> Single<[Article]> {
        let requestConfiguration = ArticleRequestConfiguration.listArticles(params: params)

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
