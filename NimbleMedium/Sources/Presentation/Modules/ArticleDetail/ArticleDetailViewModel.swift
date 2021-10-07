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

    func fetchArticleDetail()
}

protocol ArticleDetailViewModelOutput {

    var id: String { get }
    var didFailToFetchArticleDetail: Signal<Void> { get }
    var uiModel: Driver<ArticleDetailView.UIModel?> { get }
}

protocol ArticleDetailViewModelProtocol: ObservableViewModel {

    var input: ArticleDetailViewModelInput { get }
    var output: ArticleDetailViewModelOutput { get }
}

final class ArticleDetailViewModel: ObservableObject, ArticleDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    
    private let disposeBag = DisposeBag()
    private let fetchArticleDetailTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleDetail: Signal<Void>
    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleDetailView.UIModel?>

    let id: String
    var input: ArticleDetailViewModelInput { self }
    var output: ArticleDetailViewModelOutput { self }

    init(id: String) {
        self.id = id

        fetchArticleDetailTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchArticleDetailTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelInput {

    func fetchArticleDetail() {
        fetchArticleDetailTrigger.accept(())
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelOutput {}

// MARK: Private
private extension ArticleDetailViewModel {

    func fetchArticleDetailTriggered(owner: ArticleDetailViewModel) -> Observable<Void> {
        getArticleUseCase.execute(slug: id)
        .do(
            onSuccess: {
                owner.$uiModel.accept(.init(article: $0))
            },
            onError: { _ in owner.$didFailToFetchArticleDetail.accept(()) }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }
}