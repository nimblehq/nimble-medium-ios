//
//  FeedsTabViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift
import RxCocoa
import SwiftUI
import Resolver

protocol FeedsTabViewModelInput {

    func loadMore()
    func refresh()
}

protocol FeedsTabViewModelOutput {

    var tabType: Driver<FeedsTabView.TabType> { get }
    var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]> { get }
    var didFailToLoadArticle: Signal<Void> { get }
    var didFinishLoadMore: Signal<Bool> { get }
    var didFinishRefresh: Signal<Void> { get }
}

protocol FeedsTabViewModelProtocol: ObservableViewModel {

    var input: FeedsTabViewModelInput { get }
    var output: FeedsTabViewModelOutput { get }
}

final class FeedsTabViewModel: ObservableObject, FeedsTabViewModelProtocol {

    var input: FeedsTabViewModelInput { self }
    var output: FeedsTabViewModelOutput { self }

    private var currentOffset = 0
    
    private let limit = 10
    private let disposeBag = DisposeBag()
    private let refreshTrigger = PublishRelay<Void>()
    private let loadMoreTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didFailToLoadArticle: Signal<Void>
    @PublishRelayProperty var didFinishLoadMore: Signal<Bool>
    @PublishRelayProperty var didFinishRefresh: Signal<Void>
    
    @BehaviorRelayProperty([]) var articleRowViewModels: Driver<[ArticleRowViewModelProtocol]>
    @BehaviorRelayProperty(.mine) var tabType: Driver<FeedsTabView.TabType>

    private let getArticlesUseCase: GetArticlesUseCaseProtocol

    init(tabType: FeedsTabView.TabType) {
        switch tabType {
        case .mine:
            getArticlesUseCase = Resolver.resolve(GetCurrentUserFollowingArticlesUseCaseProtocol.self)
        case .global:
            getArticlesUseCase = Resolver.resolve(GetGlobalArticlesUseCaseProtocol.self)
        }

        $tabType.accept(tabType)

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

extension FeedsTabViewModel: FeedsTabViewModelInput {

    func loadMore() {
        loadMoreTrigger.accept(())
    }

    func refresh() {
        refreshTrigger.accept(())
    }
}

extension FeedsTabViewModel: FeedsTabViewModelOutput {}

// MARK: - Private

private extension FeedsTabViewModel {

    func loadMoreTriggered(owner: FeedsTabViewModel) -> Observable<Void> {
        let offset = currentOffset + limit

        return getArticlesUseCase.execute(
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

    func refreshTriggered(owner: FeedsTabViewModel) -> Observable<Void> {
        getArticlesUseCase.execute(
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
