//
//  ArticleCommentRepository.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation
import RxSwift

final class ArticleCommentRepository: ArticleCommentRepositoryProtocol {

    private let authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol
    private let networkAPI: NetworkAPIProtocol

    init(
        authenticatedNetworkAPI: AuthenticatedNetworkAPIProtocol,
        networkAPI: NetworkAPIProtocol
    ) {
        self.authenticatedNetworkAPI = authenticatedNetworkAPI
        self.networkAPI = networkAPI
    }

    func createComment(articleSlug: String, commentBody: String) -> Single<ArticleComment> {
        let requestConfiguration = ArticleCommentRequestConfiguration.createComment(
            slug: articleSlug, body: commentBody
        )

        return authenticatedNetworkAPI
            .performRequest(requestConfiguration, for: APIArticleCommentResponse.self)
            .map { $0.comment as ArticleComment }
    }

    func deleteComment(articleSlug: String, commentId: String) -> Completable {
        let requestConfiguration = ArticleCommentRequestConfiguration.deleteComment(
            slug: articleSlug, id: commentId
        )

        return authenticatedNetworkAPI.performRequest(requestConfiguration)
    }

    func getComments(slug: String) -> Single<[ArticleComment]> {
        let requestConfiguration = ArticleCommentRequestConfiguration
            .getComments(slug: slug)

        return networkAPI
            .performRequest(requestConfiguration, for: APIArticleCommentsResponse.self)
            .map { $0.comments.map { $0 as ArticleComment } }
    }
}
