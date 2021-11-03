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
    func toggleFavouriteArticle()
    func deleteArticle()
}

protocol ArticleDetailViewModelOutput {

    var id: String { get }
    var didFailToFetchArticleDetail: Signal<Void> { get }
    var didFailToToggleFollow: Signal<Void> { get }
    var didFailToToggleFavouriteArticle: Signal<Void> { get }
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
    @Injected private var toggleArticleFavoriteStatusUseCase: ToggleArticleFavoriteStatusUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let fetchArticleDetailTrigger = PublishRelay<Void>()
    private let toggleFollowUserTrigger = PublishRelay<Void>()
    private let toggleFavouriteArticleTrigger = PublishRelay<Void>()
    private let deleteArticleTrigger = PublishRelay<Void>()
    private var article: Article?
    private var articleIsFavourite: Bool = false

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleDetail: Signal<Void>
    @PublishRelayProperty var didFailToToggleFollow: Signal<Void>
    @PublishRelayProperty var didFailToToggleFavouriteArticle: Signal<Void>
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

        toggleFavouriteArticleTrigger
            .withUnretained(self)
            .flatMap { $0.0.updateToggleFavouriteArticle() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest { $0.0.toggleFavouriteArticleTriggered(owner: $0.0, isFavourite: $0.1) }
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

    func toggleFavouriteArticle() {
        toggleFavouriteArticleTrigger.accept(())
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
                    owner.articleIsFavourite = $0.favorited
                    owner.$uiModel.accept(.init(article: $0))
                },
                onError: { _ in owner.$didFailToFetchArticleDetail.accept(()) }
            )
            .asObservable()
            .withLatestFrom(
                getCurrentSessionUseCase.execute(),
                resultSelector: { article, user in (article, user) }
            )
            .do(onNext: { article, user in
                owner.$isArticleAuthor.accept(article.author.username == user?.username)
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

    private func toggleFavouriteArticleTriggered(owner: ArticleDetailViewModel, isFavourite: Bool) -> Observable<Void> {
        toggleArticleFavoriteStatusUseCase
            .execute(slug: id, isFavorite: isFavourite)
            .do(
                onError: { _ in
                    owner.$didFailToToggleFavouriteArticle.accept(())
                    owner.updateFavouriteArticle(owner.articleIsFavourite)
                },
                onCompleted: { owner.articleIsFavourite = isFavourite }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    private func updateToggleFavouriteArticle() -> Observable<Bool> {
        guard let uiModel = $uiModel.value else { return .empty() }
        updateFavouriteArticle(!uiModel.articleIsFavorited)

        return .just(!uiModel.articleIsFavorited)
    }

    private func updateFavouriteArticle(_ value: Bool) {
        var uiModel = $uiModel.value
        uiModel?.articleIsFavorited = value
        $uiModel.accept(uiModel)
    }
}
