//
//  GetListArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

protocol GetArticlesUseCaseProtocol {

    func execute(
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]>
}

// sourcery: AutoMockable
protocol GetGlobalArticlesUseCaseProtocol: GetArticlesUseCaseProtocol {}

final class GetGlobalArticlesUseCase: GetGlobalArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func execute(
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]> {
        articleRepository
            .listArticles(params: .init(limit: limit, offset: offset))
    }
}

extension GetArticlesUseCaseProtocol {

    func execute(
        limit: Int? = Constants.Article.maxPerPage,
        offset: Int?
    ) -> Single<[Article]> {

        execute(
            limit: limit,
            offset: offset
        )
    }
}
