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
    func toggleFollowUser()
}

protocol ArticleDetailViewModelOutput {

    var id: String { get }
    var didFailToFetchArticleDetail: Signal<Void> { get }
    var didFailToToggleFollow: Signal<Void> { get }
    var uiModel: Driver<ArticleDetailView.UIModel?> { get }
}

protocol ArticleDetailViewModelProtocol: ObservableViewModel {

    var input: ArticleDetailViewModelInput { get }
    var output: ArticleDetailViewModelOutput { get }
}

final class ArticleDetailViewModel: ObservableObject, ArticleDetailViewModelProtocol {

    @Injected var getArticleUseCase: GetArticleUseCaseProtocol
    @Injected var followUserUseCase: FollowUserUseCaseProtocol
    @Injected var unfollowUserUseCase: UnfollowUserUseCaseProtocol
    
    private let disposeBag = DisposeBag()
    private let fetchArticleDetailTrigger = PublishRelay<Void>()
    private let toggleFollowUserTrigger = PublishRelay<Void>()
    private var article: Article?

    @PublishRelayProperty var didFetch: Signal<Void>
    @PublishRelayProperty var didFailToFetchArticleDetail: Signal<Void>
    @PublishRelayProperty var didFailToToggleFollow: Signal<Void>
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

        toggleFollowUserTrigger
            .withUnretained(self)
            .flatMap { $0.0.toggleAuthorFollowing() }
            .debounce(.milliseconds(500), scheduler: SharingScheduler.make())
            .withUnretained(self)
            .flatMapLatest { $0.0.toggleFollowUserTriggered(owner: $0.0, following: $0.1) }
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
}

extension ArticleDetailViewModel: ArticleDetailViewModelOutput {}

// MARK: Private
private extension ArticleDetailViewModel {

    func fetchArticleDetailTriggered(owner: ArticleDetailViewModel) -> Observable<Void> {
        getArticleUseCase.execute(slug: id)
        .do(
            onSuccess: {
                owner.article = $0
                owner.$uiModel.accept(.init(article: $0))
            },
            onError: { _ in owner.$didFailToFetchArticleDetail.accept(()) }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }

    func toggleFollowUserTriggered(owner: ArticleDetailViewModel, following: Bool) -> Observable<Void> {
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

    func toggleAuthorFollowing() -> Observable<Bool> {
        guard let uiModel = $uiModel.value else { return .empty() }
        updateAuthorFollowing(!uiModel.authorIsFollowing)

        return .just(!uiModel.authorIsFollowing)
    }

    func updateAuthorFollowing(_ value: Bool) {
        var uiModel = $uiModel.value
        uiModel?.authorIsFollowing = value
        $uiModel.accept(uiModel)
    }
}
