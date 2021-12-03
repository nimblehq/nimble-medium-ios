//
//  UserProfileFavoritedArticlesViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol UserProfileFavoritedArticlesTabViewModelInput {

    func fetchFavoritedArticles()
}

// sourcery: AutoMockable
protocol UserProfileFavoritedArticlesTabViewModelOutput {

    var isLoading: Driver<Bool> { get }
    var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]> { get }
    var didFetchFavoritedArticles: Signal<Void> { get }
    var didFailToFetchFavoritedArticles: Signal<Void> { get }
}

// sourcery: AutoMockable
protocol UserProfileFavoritedArticlesTabViewModelProtocol: ObservableViewModel {

    var input: UserProfileFavoritedArticlesTabViewModelInput { get }
    var output: UserProfileFavoritedArticlesTabViewModelOutput { get }
}

final class UserProfileFavoritedArticlesTabViewModel: ObservableObject,
    UserProfileFavoritedArticlesTabViewModelProtocol {

    @Injected private var getFavoritedArticlesUseCase: GetFavoritedArticlesUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let username: String?
    private let fetchFavoritedArticlesTrigger = PublishRelay<Void>()

    @BehaviorRelayProperty(false) var isLoading: Driver<Bool>
    @BehaviorRelayProperty([]) var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]>
    @PublishRelayProperty var didFetchFavoritedArticles: Signal<Void>
    @PublishRelayProperty var didFailToFetchFavoritedArticles: Signal<Void>

    var input: UserProfileFavoritedArticlesTabViewModelInput { self }
    var output: UserProfileFavoritedArticlesTabViewModelOutput { self }

    init(username: String?) {
        self.username = username
        fetchFavoritedArticlesTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchFavoritedArticlesTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileFavoritedArticlesTabViewModel: UserProfileFavoritedArticlesTabViewModelInput {

    func fetchFavoritedArticles() {
        fetchFavoritedArticlesTrigger.accept(())
    }
}

extension UserProfileFavoritedArticlesTabViewModel: UserProfileFavoritedArticlesTabViewModelOutput {}

// MARK: Private

extension UserProfileFavoritedArticlesTabViewModel {

    private func fetchFavoritedArticlesTriggered(owner: UserProfileFavoritedArticlesTabViewModel) -> Observable<Void> {
        Observable.just(username)
            .compactMap { $0 }
            .flatMap {
                owner.getFavoritedArticlesUseCase
                    .execute(username: $0)
            }
            .asSingle()
            .do(
                onSuccess: {
                    let viewModels = $0.viewModels
                    owner.observeArticleRowViewModels(
                        owner: owner,
                        viewModels: viewModels
                    )

                    owner.$isLoading.accept(false)
                    owner.$didFetchFavoritedArticles.accept(())
                    owner.$articleRowVieModels.accept(viewModels)
                },
                onError: { _ in
                    owner.$didFailToFetchFavoritedArticles.accept(())
                    owner.$isLoading.accept(false)
                }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func observeArticleRowViewModels(owner: UserProfileFavoritedArticlesTabViewModel, viewModels: [ArticleRowViewModelProtocol]) {
        Observable.merge(
            viewModels.map {
                $0.output.isTogglingFavoriteArticle
                    .filter { $0 }
                    .asObservable()
            }
        )
        .subscribe(onNext: {
            owner.$isLoading.accept($0)
        })
        .disposed(by: owner.disposeBag)

        Observable.merge(
            viewModels.map {
                $0.output.didToggleFavoriteArticle
                    .asObservable()
                    .filter { !$0 }
                    .mapToVoid()
            }
        )
        .subscribe(onNext: {
            owner.fetchFavoritedArticles()
        })
        .disposed(by: owner.disposeBag)
    }
}
