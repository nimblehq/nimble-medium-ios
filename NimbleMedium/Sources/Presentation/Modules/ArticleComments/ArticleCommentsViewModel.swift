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

protocol ArticleCommentsViewModelInput {

    func fetch()
}

protocol ArticleCommentsViewModelOutput {

    var didFetch: Signal<Void> { get }
    var didFailToFetch: Signal<Void> { get }
    var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]> { get }
}

protocol ArticleCommentsViewModelProtocol: ObservableViewModel {

    var input: ArticleCommentsViewModelInput { get }
    var output: ArticleCommentsViewModelOutput { get }
}

final class ArticleCommentsViewModel: ObservableObject, ArticleCommentsViewModelProtocol {

    @Injected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchTrigger = PublishRelay<Void>()
    private let id: String

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetch: Signal<Void>
    @BehaviorRelayProperty([]) var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]>

    var input: ArticleCommentsViewModelInput { self }
    var output: ArticleCommentsViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelInput {

    func fetch() {
        fetchTrigger.accept(())
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelOutput {}

// MARK: Private
private extension ArticleCommentsViewModel {

    func fetchTriggered(owner: ArticleCommentsViewModel) -> Observable<Void> {
        getArticleCommentsUseCase.execute(slug: id)
            .do(
                onSuccess: {
                    owner.$didFetch.accept(())
                    owner.$articleCommentRowViewModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetch.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
