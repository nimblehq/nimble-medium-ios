//
//  FeedCommentRowViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 23/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelInput {}

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelOutput {

    var id: Int { get }
    var uiModel: Driver<ArticleCommentRow.UIModel> { get }
}

// sourcery: AutoMockable
protocol ArticleCommentRowViewModelProtocol: ObservableViewModel {

    var input: ArticleCommentRowViewModelInput { get }
    var output: ArticleCommentRowViewModelOutput { get }
}

final class ArticleCommentRowViewModel: ObservableObject, ArticleCommentRowViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: ArticleCommentRowViewModelInput { self }
    var output: ArticleCommentRowViewModelOutput { self }

    let uiModel: Driver<ArticleCommentRow.UIModel>
    let id: Int

    init(comment: ArticleComment) {
        id = comment.id
        uiModel = .just(
            .init(
                commentBody: comment.body,
                commentUpdatedAt: comment.updatedAt.format(with: .monthDayYear),
                authorName: comment.author.username,
                authorImage: try? comment.author.image?.asURL()
            )
        )
    }
}

extension ArticleCommentRowViewModel: ArticleCommentRowViewModelInput {}

extension ArticleCommentRowViewModel: ArticleCommentRowViewModelOutput {}

extension Array where Element == ArticleComment {

    var viewModels: [ArticleCommentRowViewModelProtocol] {
        map { Resolver.resolve(ArticleCommentRowViewModelProtocol.self, args: $0) }
    }
}
