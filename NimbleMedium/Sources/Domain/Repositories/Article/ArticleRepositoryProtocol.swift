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

    func favoriteArticle(slug: String) -> Single<Article>

    func getArticle(slug: String) -> Single<Article>

    func listArticles(params: GetArticlesParameters) -> Single<[Article]>

    func unfavoriteArticle(slug: String) -> Single<Article>

    func updateArticle(slug: String, params: UpdateMyArticleParameters) -> Single<Article>
}
