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

    var id: String { get }
    var didFailToFetchArticle: Signal<Void> { get }
    var feedDetailUIModel: Driver<FeedDetailView.UIModel?> { get }
}

protocol FeedDetailViewModelProtocol: ObservableViewModel {

    var input: FeedDetailViewModelInput { get }
    var output: FeedDetailViewModelOutput { get }
}

final class FeedDetailViewModel: ObservableObject, FeedDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    
    private let disposeBag = DisposeBag()
    private let fetchArticleTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didFetchArticle: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticle: Signal<Void>
    @BehaviorRelayProperty(nil) var feedDetailUIModel: Driver<FeedDetailView.UIModel?>

    let id: String
    var input: FeedDetailViewModelInput { self }
    var output: FeedDetailViewModelOutput { self }

    init(id: String) {
        self.id = id

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
        getArticleUseCase.getArticle(slug: id)
        .do(
            onSuccess: {
                owner.$feedDetailUIModel.accept(.init(article: $0))
            },
            onError: { _ in owner.$didFailToFetchArticle.accept(()) }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }
}
