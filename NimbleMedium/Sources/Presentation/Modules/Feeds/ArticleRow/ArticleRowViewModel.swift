//
//  FeedRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol ArticleRowViewModelInput {}

// sourcery: AutoMockable
protocol ArticleRowViewModelOutput {

    var id: String { get }
    var uiModel: Driver<ArticleRow.UIModel> { get }
}

// sourcery: AutoMockable
protocol ArticleRowViewModelProtocol: ObservableViewModel {

    var input: ArticleRowViewModelInput { get }
    var output: ArticleRowViewModelOutput { get }
}

final class ArticleRowViewModel: ObservableObject, ArticleRowViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: ArticleRowViewModelInput { self }
    var output: ArticleRowViewModelOutput { self }

    let uiModel: Driver<ArticleRow.UIModel>
    let id: String

    init(article: Article) {
        id = article.id
        uiModel = .just(
            .init(
                id: article.id,
                articleTitle: article.title,
                articleDescription: article.description,
                articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                authorImage: try? article.author.image?.asURL(),
                authorName: article.author.username
            )
        )
    }
}

extension ArticleRowViewModel: ArticleRowViewModelInput {}

extension ArticleRowViewModel: ArticleRowViewModelOutput {}

extension Array where Element == Article {

    var viewModels: [ArticleRowViewModelProtocol] {
        map { Resolver.resolve(ArticleRowViewModelProtocol.self, args: $0) }
    }
}
