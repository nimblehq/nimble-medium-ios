//
//  CreateArticleUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 18/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol CreateArticleUseCaseProtocol {

    func execute(params: CreateArticleParameters) -> Single<Article>
}

final class CreateArticleUseCase: CreateArticleUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    func execute(params: CreateArticleParameters) -> Single<Article> {
        articleRepository.createArticle(params: params)
    }
}
