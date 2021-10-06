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

protocol ArticleDetailViewModelInput {

    func fetch()
}

protocol ArticleDetailViewModelOutput {

    var id: String { get }
    var didFailToFetch: Signal<Void> { get }
    var uiModel: Driver<ArticleDetailView.UIModel?> { get }
}

protocol ArticleDetailViewModelProtocol: ObservableViewModel {

    var input: ArticleDetailViewModelInput { get }
    var output: ArticleDetailViewModelOutput { get }
}

final class ArticleDetailViewModel: ObservableObject, ArticleDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    
    private let disposeBag = DisposeBag()
    private let fetchTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetch: Signal<Void>
    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleDetailView.UIModel?>

    let id: String
    var input: ArticleDetailViewModelInput { self }
    var output: ArticleDetailViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelInput {

    func fetch() {
        fetchTrigger.accept(())
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelOutput {}

// MARK: Private
private extension ArticleDetailViewModel {

    func fetchArticleTriggered(owner: ArticleDetailViewModel) -> Observable<Void> {
        getArticleUseCase.execute(slug: id)
        .do(
            onSuccess: {
                owner.$uiModel.accept(.init(article: $0))
            },
            onError: { _ in owner.$didFailToFetch.accept(()) }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }
}
