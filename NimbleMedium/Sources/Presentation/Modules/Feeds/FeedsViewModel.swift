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
    var didFailToLoadArticle: Signal<Error> { get }
    var didFinishLoadMore: Signal<Bool> { get }
    var didFinishRefresh: Signal<Void> { get }
    var articles: Driver<[Article]> { get }
}

protocol FeedsViewModelProtocol: ObservableViewModel {

    var input: FeedsViewModelInput { get }
    var output: FeedsViewModelOutput { get }
}

final class FeedsViewModel: ObservableObject, FeedsViewModelProtocol {

    let listArticlesUseCase: ListArticlesUseCaseProtocol = Resolver.resolve()
    var currentOffset = 0
    let limit = 10
    let disposeBag = DisposeBag()
    let refreshTrigger = PublishRelay<Void>()
    let loadMoreTrigger = PublishRelay<Void>()

    @PublishRelayProperty var didToggleSideMenu: Signal<Void>
    @PublishRelayProperty var didFailToLoadArticle: Signal<Error>
    @PublishRelayProperty var didFinishLoadMore: Signal<Bool>
    @PublishRelayProperty var didFinishRefresh: Signal<Void>
    @BehaviorRelayProperty([]) var articles: Driver<[Article]>

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
        listArticlesUseCase.listArticles(
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
                owner.$articles.accept(self.$articles.value + $0)
            },
            onError: {
                owner.$didFinishRefresh.accept(())
                owner.$didFailToLoadArticle.accept($0)
            }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }

    func loadMoreTriggered(owner: FeedsViewModel) -> Observable<Void> {
        let offset = currentOffset + limit

        return listArticlesUseCase.listArticles(
            tag: nil,
            author: nil,
            favorited: nil,
            limit: limit,
            offset: offset
        )
        .do(
            onSuccess: {
                owner.$didFinishLoadMore.accept(!$0.isEmpty)
                owner.$articles.accept(owner.$articles.value + $0)

                if !$0.isEmpty {
                    owner.currentOffset = offset
                }
            },
            onError: {
                owner.$didFinishLoadMore.accept(true)
                owner.$didFailToLoadArticle.accept($0)
            }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }
}
