//
//  GetFavouritedArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 28/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetFavouritedArticlesUseCaseProtocol {

    func execute(username: String) -> Single<[Article]>
}

final class GetFavouritedArticlesUseCase: GetFavouritedArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func execute(username: String) -> Single<[Article]> {
        articleRepository
            .listArticles( params: .init(favorited: username, limit: 25))
    }
}
