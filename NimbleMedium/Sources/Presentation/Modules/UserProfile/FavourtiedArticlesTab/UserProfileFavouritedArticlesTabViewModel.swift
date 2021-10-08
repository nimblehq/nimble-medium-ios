//
//  UserProfileFavouritedArticlesViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol UserProfileFavouritedArticlesTabViewModelInput {

    func fetchFavouritedArticles()
}

// sourcery: AutoMockable
protocol UserProfileFavouritedArticlesTabViewModelOutput {

    var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]> { get }
    var didFetchFavouritedArticles: Signal<Void> { get }
    var didFailToFetchFavouritedArticles: Signal<Void> { get }
}

// sourcery: AutoMockable
protocol UserProfileFavouritedArticlesTabViewModelProtocol: ObservableViewModel {

    var input: UserProfileFavouritedArticlesTabViewModelInput { get }
    var output: UserProfileFavouritedArticlesTabViewModelOutput { get }
}

// swiftlint:disable type_name
final class UserProfileFavouritedArticlesTabViewModel: ObservableObject,
                                                       UserProfileFavouritedArticlesTabViewModelProtocol {

    @Injected private var getFavouritedArticlesUseCase: GetFavouritedArticlesUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let username: String?
    private let fetchFavouritedArticlesTrigger = PublishRelay<Void>()

    @BehaviorRelayProperty([]) var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]>
    @PublishRelayProperty var didFetchFavouritedArticles: Signal<Void>
    @PublishRelayProperty var didFailToFetchFavouritedArticles: Signal<Void>

    var input: UserProfileFavouritedArticlesTabViewModelInput { self }
    var output: UserProfileFavouritedArticlesTabViewModelOutput { self }

    init(username: String?) {
        self.username = username
        fetchFavouritedArticlesTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchFavouritedArticlesTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileFavouritedArticlesTabViewModel: UserProfileFavouritedArticlesTabViewModelInput {

    func fetchFavouritedArticles() {
        fetchFavouritedArticlesTrigger.accept(())
    }
}

extension UserProfileFavouritedArticlesTabViewModel: UserProfileFavouritedArticlesTabViewModelOutput {}

// MARK: Private
private extension UserProfileFavouritedArticlesTabViewModel {

    func fetchFavouritedArticlesTriggered(owner: UserProfileFavouritedArticlesTabViewModel) -> Observable<Void> {
        // TODO: Get current user articles
        guard let username = username else {
            return .just(())
        }

        return getFavouritedArticlesUseCase
            .execute(username: username)
            .do(
                onSuccess: {
                    owner.$didFetchFavouritedArticles.accept(())
                    owner.$articleRowVieModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetchFavouritedArticles.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
