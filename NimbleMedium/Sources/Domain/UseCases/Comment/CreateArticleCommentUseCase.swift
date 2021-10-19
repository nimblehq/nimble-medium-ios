//
//  CreateArticleCommentUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 19/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol CreateArticleCommentUseCaseProtocol {

    func execute(articleSlug: String, commentBody: String) -> Single<ArticleComment>
}

final class CreateArticleCommentUseCase: CreateArticleCommentUseCaseProtocol {

    private let articleCommentRepository: ArticleCommentRepositoryProtocol

    init(
        articleCommentRepository: ArticleCommentRepositoryProtocol
    ) {
        self.articleCommentRepository = articleCommentRepository
    }

    func execute(articleSlug: String, commentBody: String) -> Single<ArticleComment> {
        articleCommentRepository.createComment(articleSlug: articleSlug, commentBody: commentBody)
    }
}
