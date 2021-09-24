//
//  FeedCommentsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 17/09/2021.
//

import RxSwift
import RxCocoa
import Combine
import Resolver

protocol FeedCommentsViewModelInput {

    func fetchComments()
}

protocol FeedCommentsViewModelOutput {

    var didFetchComments: Signal<Void> { get }
    var didFailToFetchComments: Signal<Void> { get }
    var feedCommentRowViewModels: Driver<[FeedCommentRowViewModelProtocol]> { get }
}

protocol FeedCommentsViewModelProtocol: ObservableViewModel {

    var input: FeedCommentsViewModelInput { get }
    var output: FeedCommentsViewModelOutput { get }
}

final class FeedCommentsViewModel: ObservableObject, FeedCommentsViewModelProtocol {

    @Injected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchCommentsTrigger = PublishRelay<Void>()
    private let id: String

    @PublishRelayProperty var didFetchComments: Signal<Void>
    @PublishRelayProperty var didFailToFetchComments: Signal<Void>
    @BehaviorRelayProperty([]) var feedCommentRowViewModels: Driver<[FeedCommentRowViewModelProtocol]>

    var input: FeedCommentsViewModelInput { self }
    var output: FeedCommentsViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchCommentsTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchCommentsTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FeedCommentsViewModel: FeedCommentsViewModelInput {

    func fetchComments() {
        fetchCommentsTrigger.accept(())
    }
}

extension FeedCommentsViewModel: FeedCommentsViewModelOutput {}

// MARK: Private
private extension FeedCommentsViewModel {

    func fetchCommentsTriggered(owner: FeedCommentsViewModel) -> Observable<Void> {
        getArticleCommentsUseCase.getComments(slug: id)
            .do(
                onSuccess: {
                    owner.$didFetchComments.accept(())
                    owner.$feedCommentRowViewModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetchComments.accept(()) }
            )
            .asObservable()
            .map { _ in () }
            .catchAndReturn(())
    }
}

private extension Array where Element == ArticleComment {

    var viewModels: [FeedCommentRowViewModelProtocol] {
        map { Resolver.resolve(FeedCommentRowViewModelProtocol.self, args: $0) }
    }
}
