//
//  DeleteMyArticleUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 25/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol DeleteMyArticleUseCaseProtocol {

    func execute(slug: String) -> Completable
}

final class DeleteMyArticleUseCase: DeleteMyArticleUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    func execute(slug: String) -> Completable {
        articleRepository.deleteArticle(slug: slug)
    }
}
