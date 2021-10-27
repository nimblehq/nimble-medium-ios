//
//  ToggleArticleFavoriteStatusUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 27/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol ToggleArticleFavoriteStatusUseCaseProtocol: AnyObject {

    func execute(slug: String, isFavorite: Bool) -> Completable
}

final class ToggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol

    init(articleRepository: ArticleRepositoryProtocol) {
        self.articleRepository = articleRepository
    }

    func execute(slug: String, isFavorite: Bool) -> Completable {
        if isFavorite {
            return articleRepository
                .favoriteArticle(slug: slug)
                .asCompletable()
        } else {
            return articleRepository
                .unfavoriteArticle(slug: slug)
                .asCompletable()
        }
    }
}
