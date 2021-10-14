//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift
import RxCocoa
import SwiftUI
import Resolver

protocol FeedsViewModelInput {

    func loadMore()
    func refresh()
    func toggleSideMenu()
    func viewOnAppear()
}

protocol FeedsViewModelOutput {

    var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]> { get }
    var didToggleSideMenu: Signal<Void> { get }
    var didFailToLoadArticle: Signal<Void> { get }
    var didFinishLoadMore: Signal<Bool> { get }
    var didFinishRefresh: Signal<Void> { get }
    var isAuthenticated: Driver<Bool> { get }
}

protocol FeedsViewModelProtocol: ObservableViewModel {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: ObservableObject, FeedsViewModelProtocol {

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

    private var currentOffset = 0
    
    private let limit = 10
    private let disposeBag = DisposeBag()
    private let refreshTrigger = PublishRelay<Void>()
    private let loadMoreTrigger = PublishRelay<Void>()
    private let getCurrentUserSessionTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didToggleSideMenu: Signal<Void>
    @PublishRelayProperty var didFailToLoadArticle: Signal<Void>
    @PublishRelayProperty var didFinishLoadMore: Signal<Bool>
    @PublishRelayProperty var didFinishRefresh: Signal<Void>
    
    @BehaviorRelayProperty([]) var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]>
    @BehaviorRelayProperty(false) var isAuthenticated: Driver<Bool>

    @Injected private var getCurrentSessionUseCase: GetCurrentSessionUseCaseProtocol
    @Injected private var getListArticlesUseCase: GetListArticlesUseCaseProtocol

    init() {
        getCurrentUserSessionTrigger
            .withUnretained(self)
            .flatMapLatest { owner, _ in owner.getCurrentUserSessionTriggered(owner: owner) }
            .subscribe()
            .disposed(by: disposeBag)

        loadMoreTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.loadMoreTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)

        refreshTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.refreshTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FeedsViewModel: FeedsViewModelInput {

    func loadMore() {
        loadMoreTrigger.accept(())
    }

    func refresh() {
        refreshTrigger.accept(())
    }

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }

    func viewOnAppear() {
        getCurrentUserSessionTrigger.accept(())
        refresh()
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}

// MARK: - Private

private extension FeedsViewModel {

    func getCurrentUserSessionTriggered(owner: FeedsViewModel) -> Observable<Void> {
        getCurrentSessionUseCase
            .getCurrentUserSession()
            .map { $0 != nil }
            .do(
                onSuccess: { owner.$isAuthenticated.accept($0) },
                onError: { _ in owner.$isAuthenticated.accept(false) }
            )
            .asObservable()
            .mapToVoid()
            .catchAndReturn(())
    }

    func loadMoreTriggered(owner: FeedsViewModel) -> Observable<Void> {
        let offset = currentOffset + limit

        return getListArticlesUseCase.execute(
            tag: nil,
            author: nil,
            favorited: nil,
            limit: limit,
            offset: offset
        )
        .do(
            onSuccess: {
                owner.$didFinishLoadMore.accept(!$0.isEmpty)
                owner.$articleRowViewModels.accept(owner.$articleRowViewModels.value + $0.viewModels)

                if !$0.isEmpty {
                    owner.currentOffset = offset
                }
            },
            onError: { _ in
                owner.$didFinishLoadMore.accept(true)
                owner.$didFailToLoadArticle.accept(())
            }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }

    func refreshTriggered(owner: FeedsViewModel) -> Observable<Void> {
        getListArticlesUseCase.execute(
            tag: nil,
            author: nil,
            favorited: nil,
            limit: limit,
            offset: 0
        )
        .do(
            onSuccess: {
                owner.$didFinishRefresh.accept(())
                owner.currentOffset = 0
                owner.$articleRowViewModels.accept($0.viewModels)
            },
            onError: { _ in
                owner.$didFinishRefresh.accept(())
                owner.$didFailToLoadArticle.accept(())
            }
        )
        .asObservable()
        .mapToVoid()
        .catchAndReturn(())
    }
}
