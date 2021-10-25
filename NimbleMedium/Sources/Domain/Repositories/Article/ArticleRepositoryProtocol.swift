//
//  ArticleRepositoryProtocol.swift
//  NimbleMedium
//
//  Created by Mark G on 06/09/2021.
//

import RxSwift

// sourcery: AutoMockable
protocol ArticleRepositoryProtocol: AnyObject {

    func createArticle(params: CreateArticleParameters) -> Single<Article>

    func deleteArticle(slug: String) -> Completable

    func listArticles(params: GetArticlesParameters) -> Single<[Article]>

    func getArticle(slug: String) -> Single<Article>
}
