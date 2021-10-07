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

    func fetchArticleComments()
}

protocol ArticleCommentsViewModelOutput {

    var didFetchArticleComments: Signal<Void> { get }
    var didFailToFetchArticleComments: Signal<Void> { get }
    var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]> { get }
}

protocol ArticleCommentsViewModelProtocol: ObservableViewModel {

    var input: ArticleCommentsViewModelInput { get }
    var output: ArticleCommentsViewModelOutput { get }
}

final class ArticleCommentsViewModel: ObservableObject, ArticleCommentsViewModelProtocol {

    @Injected var getArticleCommentsUseCase: GetArticleCommentsUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchArticleCommentsTrigger = PublishRelay<Void>()
    private let id: String

    @PublishRelayProperty var didFetchArticleComments: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleComments: Signal<Void>
    @BehaviorRelayProperty([]) var articleCommentRowViewModels: Driver<[ArticleCommentRowViewModelProtocol]>

    var input: ArticleCommentsViewModelInput { self }
    var output: ArticleCommentsViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchArticleCommentsTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleCommentsTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelInput {

    func fetchArticleComments() {
        fetchArticleCommentsTrigger.accept(())
    }
}

extension ArticleCommentsViewModel: ArticleCommentsViewModelOutput {}

// MARK: Private
private extension ArticleCommentsViewModel {

    func fetchArticleCommentsTriggered(owner: ArticleCommentsViewModel) -> Observable<Void> {
        getArticleCommentsUseCase.execute(slug: id)
            .do(
                onSuccess: {
                    owner.$didFetchArticleComments.accept(())
                    owner.$articleCommentRowViewModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetchArticleComments.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
