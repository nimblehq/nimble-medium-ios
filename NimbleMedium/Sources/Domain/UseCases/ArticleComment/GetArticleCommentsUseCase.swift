//
//  GetArticleCommentsUseCase.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol GetArticleCommentsUseCaseProtocol {

    func execute(slug: String) -> Single<[ArticleComment]>
}

final class GetArticleCommentsUseCase: GetArticleCommentsUseCaseProtocol {

    private let articleCommentRepository: ArticleCommentRepositoryProtocol

    init(
        articleCommentRepository: ArticleCommentRepositoryProtocol
    ) {
        self.articleCommentRepository = articleCommentRepository
    }

    func execute(slug: String) -> Single<[ArticleComment]> {
        articleCommentRepository.getComments(slug: slug)
    }
}
