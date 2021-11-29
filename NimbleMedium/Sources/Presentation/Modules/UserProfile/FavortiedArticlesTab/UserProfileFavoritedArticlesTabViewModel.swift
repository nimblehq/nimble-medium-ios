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
                    owner.$didFetchFavoritedArticles.accept(())
                    owner.$articleRowVieModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetchFavoritedArticles.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
