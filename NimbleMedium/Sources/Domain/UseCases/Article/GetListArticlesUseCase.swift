//
//  GetListArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetListArticlesUseCaseProtocol {

    func listArticles(
        tag: String?,
        author: String?,
        favorited: String?,
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]>
}

final class GetListArticlesUseCase: GetListArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func listArticles(
        tag: String?,
        author: String?,
        favorited: String?,
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]> {
        articleRepository.listArticles(
            tag: tag,
            author: author,
            favorited: favorited,
            limit: limit,
            offset: offset
        )
    }
}

extension GetListArticlesUseCaseProtocol {

    func listArticles(
        tag: String?,
        author: String?,
        favorited: String?,
        limit: Int? = Constants.Article.maxPerPage,
        offset: Int?
    ) -> Single<[Article]> {

        listArticles(
            tag: tag,
            author: author,
            favorited: favorited,
            limit: limit,
            offset: offset
        )
    }
}
