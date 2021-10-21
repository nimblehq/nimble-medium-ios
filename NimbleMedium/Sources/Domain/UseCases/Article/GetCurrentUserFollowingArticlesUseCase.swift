//
//  GetFollowingArticlesUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 20/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetCurrentUserFollowingArticlesUseCaseProtocol: GetArticlesUseCaseProtocol {}

final class GetCurrentUserFollowingArticlesUseCase: GetCurrentUserFollowingArticlesUseCaseProtocol {

    private let articleRepository: ArticleRepositoryProtocol
    private let getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol

    init(
        articleRepository: ArticleRepositoryProtocol,
        getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    ) {
        self.articleRepository = articleRepository
        self.getCurrentSessionUseCase = getCurrentSessionUseCase
    }

    func execute(
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]> {
        getCurrentSessionUseCase.execute()
            .flatMap {
                guard let user = $0 else {
                    return .error(NetworkAPIError.generic)
                }

                return self.articleRepository.listArticles(
                    tag: nil,
                    author: nil,
                    favorited: user.username,
                    limit: limit,
                    offset: offset
                )
            }
    }
}
