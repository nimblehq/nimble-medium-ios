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
protocol FeedRowViewModelInput {}

// sourcery: AutoMockable
protocol FeedRowViewModelOutput {

    var id: String { get }
    var uiModel: Driver<FeedRow.UIModel> { get }
}

// sourcery: AutoMockable
protocol FeedRowViewModelProtocol: ObservableViewModel {

    var input: FeedRowViewModelInput { get }
    var output: FeedRowViewModelOutput { get }
}

final class FeedRowViewModel: ObservableObject, FeedRowViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: FeedRowViewModelInput { self }
    var output: FeedRowViewModelOutput { self }

    let uiModel: Driver<FeedRow.UIModel>
    let id: String

    init(article: Article) {
        id = article.id
        self.uiModel = .just(
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

extension FeedRowViewModel: FeedRowViewModelInput {}

extension FeedRowViewModel: FeedRowViewModelOutput {}
