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

    func toggleSideMenu()
    func refresh()
    func loadMore()
}

protocol FeedsViewModelOutput {

    var didToggleSideMenu: Signal<Void> { get }
    var didFailToLoadArticle: Signal<Void> { get }
    var didFinishLoadMore: Signal<Bool> { get }
    var didFinishRefresh: Signal<Void> { get }
    var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]> { get }
}

protocol FeedsViewModelProtocol: ObservableViewModel {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: ObservableObject, FeedsViewModelProtocol {

    @Injected private var getListArticlesUseCase: GetListArticlesUseCaseProtocol

    private var currentOffset = 0
    private let limit = 10
    private let disposeBag = DisposeBag()
    private let refreshTrigger = PublishRelay<Void>()
    private let loadMoreTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didToggleSideMenu: Signal<Void>
    @PublishRelayProperty var didFailToLoadArticle: Signal<Void>
    @PublishRelayProperty var didFinishLoadMore: Signal<Bool>
    @PublishRelayProperty var didFinishRefresh: Signal<Void>
    @BehaviorRelayProperty([]) var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]>

    var input: FeedsViewModelInput { self }
    var output: FeedsViewModelOutput { self }

    init() {
        refreshTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.refreshTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)

        loadMoreTrigger
            .withUnretained(self)
            .flatMapLatest { $0.0.loadMoreTriggered(owner: $0.0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension FeedsViewModel: FeedsViewModelInput {

    func toggleSideMenu() {
        $didToggleSideMenu.accept(())
    }

    func refresh() {
        refreshTrigger.accept(())
    }

    func loadMore() {
        loadMoreTrigger.accept(())
    }
}

extension FeedsViewModel: FeedsViewModelOutput {}

// MARK: - Private

private extension FeedsViewModel {

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
}
