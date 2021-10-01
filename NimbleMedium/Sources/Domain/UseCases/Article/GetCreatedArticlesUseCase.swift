//
//  GetCreatedArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 28/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetCreatedArticlesUseCaseProtocol {

    func execute(username: String) -> Single<[Article]>
}

final class GetCreatedArticlesUseCase: GetCreatedArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func execute(username: String) -> Single<[Article]> {
        articleRepository.listArticles(
            tag: nil,
            author: username,
            favorited: nil,
            limit: 25,
            offset: nil
        )
    }
}
