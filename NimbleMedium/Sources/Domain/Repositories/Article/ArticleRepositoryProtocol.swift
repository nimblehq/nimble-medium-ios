//
//  ArticleRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol ArticleRepositoryProtocol: AnyObject {

    func listArticles(
        tag: String?,
        author: String?,
        favorited: String?,
        limit: Int?,
        offset: Int?
    ) -> Single<[Article]>
}