//
//  UpdateMyArticleUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 26/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol UpdateMyArticleUseCaseProtocol: AnyObject {

    func execute(slug: String, params: UpdateMyArticleParameters) -> Completable
}

final class UpdateMyArticleUseCase: UpdateMyArticleUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    func execute(slug: String, params: UpdateMyArticleParameters) -> Completable {
        articleRepository
            .updateArticle(slug: slug, params: params)
            .asCompletable()
    }
}
