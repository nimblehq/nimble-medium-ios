//
//  GetArticleUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 14/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetArticleUseCaseProtocol {

    func execute(slug: String) -> Single<Article>
}

final class GetArticleUseCase: GetArticleUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(
        articleRepository: ArticleRepositoryProtocol
    ) {
        self.articleRepository = articleRepository
    }

    func execute(slug: String) -> Single<Article> {
        articleRepository.getArticle(slug: slug)
    }
}
