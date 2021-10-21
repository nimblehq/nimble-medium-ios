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
        articleRepository
            .listArticles(params: .init(author: username, limit: 25))
    }
}
