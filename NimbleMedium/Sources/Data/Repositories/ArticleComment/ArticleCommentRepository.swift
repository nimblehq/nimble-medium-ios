//
//  ArticleCommentRepository.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Foundation
import RxSwift

final class ArticleCommentRepository: ArticleCommentRepositoryProtocol {

    private let networkAPI: NetworkAPIProtocol

    init(networkAPI: NetworkAPIProtocol) {
        self.networkAPI = networkAPI
    }
    
    func getComments(slug: String) -> Single<[ArticleComment]> {
        let requestConfiguration = ArticleCommentRequestConfiguration
            .getComments(slug: slug)

        return networkAPI
            .performRequest(requestConfiguration, for: APIArticleCommentsResponse.self)
            .map { $0.comments.map { $0 as ArticleComment } }
    }
}
