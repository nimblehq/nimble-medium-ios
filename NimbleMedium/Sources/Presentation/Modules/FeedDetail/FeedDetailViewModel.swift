//
//  FeedDetailViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import RxSwift
import RxCocoa
import Combine
import Resolver

protocol FeedDetailViewModelInput {

    func fetchArticle()
}

protocol FeedDetailViewModelOutput {

    var didFailToFetchArticle: Signal<Void> { get }
    var feedDetailUIModel: Driver<FeedDetailView.UIModel?> { get }
}

protocol FeedDetailViewModelProtocol: ObservableViewModel {

    var input: FeedDetailViewModelInput { get }
    var output: FeedDetailViewModelOutput { get }
}

final class FeedDetailViewModel: ObservableObject, FeedDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    
    let disposeBag = DisposeBag()
    let fetchArticleTrigger = PublishRelay<Void>()
    let slug: String

    @PublishRelayProperty var didFetchArticle: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticle: Signal<Void>
    @BehaviorRelayProperty(nil) var feedDetailUIModel: Driver<FeedDetailView.UIModel?>

    var input: FeedDetailViewModelInput { self }
    var output: FeedDetailViewModelOutput { self }

    init(slug: String) {
        self.slug = slug

        fetchArticleTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FeedDetailViewModel: FeedDetailViewModelInput {

    func fetchArticle() {
        fetchArticleTrigger.accept(())
    }
}

extension FeedDetailViewModel: FeedDetailViewModelOutput {}

// MARK: Private
private extension FeedDetailViewModel {

    func fetchArticleTriggered(owner: FeedDetailViewModel) -> Observable<Void> {
        getArticleUseCase.getArticle(slug: slug)
        .do(
            onSuccess: {
                owner.$feedDetailUIModel.accept(.init(article: $0))
            },
            onError: { _ in owner.$didFailToFetchArticle.accept(()) }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }
}
