//
//  UserProfileCreatedArticlesViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 06/10/2021.
//

import Combine
import Resolver
import RxCocoa
import RxSwift

// sourcery: AutoMockable
protocol UserProfileCreatedArticlesTabViewModelInput {

    func fetchCreatedArticles()
}

// sourcery: AutoMockable
protocol UserProfileCreatedArticlesTabViewModelOutput {

    var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]> { get }
    var didFetchCreatedArticles: Signal<Void> { get }
    var didFailToFetchCreatedArticles: Signal<Void> { get }
}

// sourcery: AutoMockable
protocol UserProfileCreatedArticlesTabViewModelProtocol: ObservableViewModel {

    var input: UserProfileCreatedArticlesTabViewModelInput { get }
    var output: UserProfileCreatedArticlesTabViewModelOutput { get }
}

final class UserProfileCreatedArticlesTabViewModel: ObservableObject, UserProfileCreatedArticlesTabViewModelProtocol {

    @Injected private var getCreatedArticlesUseCase: GetCreatedArticlesUseCaseProtocol

    private let disposeBag = DisposeBag()
    private let username: String?
    private let fetchCreatedArticlesTrigger = PublishRelay<Void>()

    @BehaviorRelayProperty([]) var articleRowVieModels: Driver<[ArticleRowViewModelProtocol]>
    @PublishRelayProperty var didFetchCreatedArticles: Signal<Void>
    @PublishRelayProperty var didFailToFetchCreatedArticles: Signal<Void>

    var input: UserProfileCreatedArticlesTabViewModelInput { self }
    var output: UserProfileCreatedArticlesTabViewModelOutput { self }

    init(username: String?) {
        self.username = username
        fetchCreatedArticlesTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.fetchCreatedArticlesTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UserProfileCreatedArticlesTabViewModel: UserProfileCreatedArticlesTabViewModelInput {

    func fetchCreatedArticles() {
        fetchCreatedArticlesTrigger.accept(())
    }
}

extension UserProfileCreatedArticlesTabViewModel: UserProfileCreatedArticlesTabViewModelOutput {}

// MARK: Private

extension UserProfileCreatedArticlesTabViewModel {

    private func fetchCreatedArticlesTriggered(owner: UserProfileCreatedArticlesTabViewModel) -> Observable<Void> {
        Observable.just(username)
            .compactMap { $0 }
            .flatMap {
                owner.getCreatedArticlesUseCase
                    .execute(username: $0)
            }
            .asSingle()
            .do(
                onSuccess: {
                    owner.$didFetchCreatedArticles.accept(())
                    owner.$articleRowVieModels.accept($0.viewModels)
                },
                onError: { _ in owner.$didFailToFetchCreatedArticles.accept(()) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }
}
