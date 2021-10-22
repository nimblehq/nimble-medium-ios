//
//  DeleteArticleCommentUseCase.swift
//  NimbleMedium
//
//  Created by Minh Pham on 21/10/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol DeleteArticleCommentUseCaseProtocol {

    func execute(articleSlug: String, commentId: String) -> Completable
}

final class DeleteArticleCommentUseCase: DeleteArticleCommentUseCaseProtocol {

    private let articleCommentRepository: ArticleCommentRepositoryProtocol

    init(articleCommentRepository: ArticleCommentRepositoryProtocol) {
        self.articleCommentRepository = articleCommentRepository
    }

    func execute(articleSlug: String, commentId: String) -> Completable {
        articleCommentRepository.deleteComment(articleSlug: articleSlug, commentId: commentId)
    }
}
