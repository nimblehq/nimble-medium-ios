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
protocol FeedCommentRowViewModelInput {}

// sourcery: AutoMockable
protocol FeedCommentRowViewModelOutput {

    var id: Int { get }
    var uiModel: Driver<FeedCommentRow.UIModel > { get }
}

// sourcery: AutoMockable
protocol FeedCommentRowViewModelProtocol: ObservableViewModel {

    var input: FeedCommentRowViewModelInput { get }
    var output: FeedCommentRowViewModelOutput { get }
}

final class FeedCommentRowViewModel: ObservableObject, FeedCommentRowViewModelProtocol {

    private let disposeBag = DisposeBag()

    var input: FeedCommentRowViewModelInput { self }
    var output: FeedCommentRowViewModelOutput { self }

    let uiModel: Driver<FeedCommentRow.UIModel>
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

extension FeedCommentRowViewModel: FeedCommentRowViewModelInput {}

extension FeedCommentRowViewModel: FeedCommentRowViewModelOutput {}
