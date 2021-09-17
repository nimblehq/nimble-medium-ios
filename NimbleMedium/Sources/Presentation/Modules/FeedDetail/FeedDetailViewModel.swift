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

    var didFetchArticle: Signal<Void> { get }
    var didFailToFetchArticle: Signal<Void> { get }
    var articleTitle: Driver<String> { get }
    var articleBody: Driver<String> { get }
    var articleUpdatedAt: Driver<String> { get }
    var authorName: Driver<String> { get }
    var authorImage: Driver<URL?> { get }
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
    @BehaviorRelayProperty("") var articleTitle: Driver<String>
    @BehaviorRelayProperty("") var articleBody: Driver<String>
    @BehaviorRelayProperty("") var authorName: Driver<String>
    @BehaviorRelayProperty(nil) var authorImage: Driver<URL?>
    @BehaviorRelayProperty("") var articleUpdatedAt: Driver<String>

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
                owner.$articleTitle.accept($0.title)
                owner.$articleBody.accept($0.body)
                owner.$articleUpdatedAt.accept($0.updatedAt.format(with: .monthDayYear))
                owner.$authorName.accept($0.author.username)
                owner.$authorImage.accept(try? $0.author.image?.asURL())
                owner.$didFetchArticle.accept(())
            },
            onError: { _ in owner.$didFailToFetchArticle.accept(()) }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }
}
