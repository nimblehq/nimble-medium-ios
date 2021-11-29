//
//  GetFavoritedArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 28/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetFavoritedArticlesUseCaseProtocol {

    func execute(username: String) -> Single<[Article]>
}

final class GetFavoritedArticlesUseCase: GetFavoritedArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func execute(username: String) -> Single<[Article]> {
        articleRepository
            .listArticles(params: .init(favorited: username, limit: 25))
    }
}
