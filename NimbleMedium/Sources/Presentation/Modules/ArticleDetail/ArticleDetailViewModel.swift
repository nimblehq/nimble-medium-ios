//
//  FeedDetailViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 15/09/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

protocol ArticleDetailViewModelInput {

    func fetchArticleDetail()
    func toggleFollowUser()
    func deleteArticle()
}

protocol ArticleDetailViewModelOutput {

    var id: String { get }
    var didFailToFetchArticleDetail: Signal<Void> { get }
    var didFailToToggleFollow: Signal<Void> { get }
    var uiModel: Driver<ArticleDetailView.UIModel?> { get }
    var didDeleteArticle: Signal<Void> { get }
    var didFailToDeleteArticle: Signal<Void> { get }
    var isLoading: Driver<Bool> { get }
    var isArticleAuthor: Driver<Bool> { get }
}

protocol ArticleDetailViewModelProtocol: ObservableViewModel {

    var input: ArticleDetailViewModelInput { get }
    var output: ArticleDetailViewModelOutput { get }
}

final class ArticleDetailViewModel: ObservableObject, ArticleDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    @Injected var followUserUseCase: FollowUserUseCaseProtocol
    @Injected var unfollowUserUseCase: UnfollowUserUseCaseProtocol
    @Injected var deleteArticleUseCase: DeleteMyArticleUseCaseProtocol
    @Injected var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchArticleDetailTrigger = PublishRelay<Void>()
    private let toggleFollowUserTrigger = PublishRelay<Void>()
    private let deleteArticleTrigger = PublishRelay<Void>()
    private var article: Article?

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleDetail: Signal<Void>
    @PublishRelayProperty var didFailToToggleFollow: Signal<Void>
    @PublishRelayProperty var didDeleteArticle: Signal<Void>
    @PublishRelayProperty var didFailToDeleteArticle: Signal<Void>
    @BehaviorRelayProperty(nil) var uiModel: Driver<ArticleDetailView.UIModel?>
    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @BehaviorRelayProperty(false) var isArticleAuthor: Driver<Bool>

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

        toggleFollowUserTrigger
            .withUnretained(self)
            .flatMap { $0.0.toggleAuthorFollowing() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest { $0.0.toggleFollowUserTriggered(owner: $0.0, following: $0.1) }
            .subscribe()
            .disposed(by: disposeBag)

        deleteArticleTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.deleteArticleTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelInput {

    func fetchArticleDetail() {
        fetchArticleDetailTrigger.accept(())
    }

    func toggleFollowUser() {
        toggleFollowUserTrigger.accept(())
    }

    func deleteArticle() {
        $isLoading.accept(true)
        deleteArticleTrigger.accept(())
    }
}

extension ArticleDetailViewModel: ArticleDetailViewModelOutput {}

// MARK: Private

extension ArticleDetailViewModel {

    private func fetchArticleDetailTriggered(owner: ArticleDetailViewModel) -> Observable<Void> {
        getArticleUseCase
            .execute(slug: id)
            .do(
                onSuccess: {
                    owner.article = $0
                    owner.$uiModel.accept(.init(article: $0))
                },
                onError: { _ in owner.$didFailToFetchArticleDetail.accept(()) }
            )
            .asObservable()
            .withLatestFrom(
                getCurrentSessionUseCase.execute(),
                resultSelector: { ($0, $1) }
            )
            .do(onNext: {
                owner.$isArticleAuthor.accept($0.author.username == $1?.username)
            })
            .mapToVoid()
            .catchAndReturn(())
    }

    private func toggleFollowUserTriggered(owner: ArticleDetailViewModel, following: Bool) -> Observable<Void> {
        guard let author = article?.author else {
            owner.$didFailToToggleFollow.accept(())
            owner.updateAuthorFollowing(!following)
            return .empty()
        }

        var completable: Completable?
        switch following {
        case true:
            completable = owner.followUserUseCase
                .execute(username: author.username)
        case false:
            completable = owner.unfollowUserUseCase
                .execute(username: author.username)
        }

        return completable?
            .do(
                onError: { _ in
                    owner.$didFailToToggleFollow.accept(())
                    owner.updateAuthorFollowing(!following)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(()) ?? .empty()
    }

    private func deleteArticleTriggered(owner: ArticleDetailViewModel) -> Observable<Void> {
        deleteArticleUseCase.execute(slug: id)
            .do(
                onError: { _ in
                    owner.$isLoading.accept(false)
                    owner.$didFailToDeleteArticle.accept(())
                },
                onCompleted: {
                    owner.$isLoading.accept(false)
                    owner.$didDeleteArticle.accept(())
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func toggleAuthorFollowing() -> Observable<Bool> {
        guard let uiModel = $uiModel.value else { return .empty() }
        updateAuthorFollowing(!uiModel.authorIsFollowing)

        return .just(!uiModel.authorIsFollowing)
    }

    private func updateAuthorFollowing(_ value: Bool) {
        var uiModel = $uiModel.value
        uiModel?.authorIsFollowing = value
        $uiModel.accept(uiModel)
    }
}
