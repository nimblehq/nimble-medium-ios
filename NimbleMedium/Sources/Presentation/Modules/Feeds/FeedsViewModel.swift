//
//  FeedsViewModel.swift
//  NimbleMedium
//
//  Created by Mark G on 12/08/2021.
//

import RxSwift
import RxCocoa
import SwiftUI

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

    let listArticlesUseCase: ListArticlesUseCaseProtocol
    var currentOffset: Int = 0
    let limit: Int = 10
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

    init(factory: ModuleFactoryProtocol) {
        self.listArticlesUseCase = factory.listArticlesUseCase()

        refreshTrigger
            .flatMapLatest { [weak self] in
                self?.refreshTriggered() ?? .empty()
            }
            .subscribe()
            .disposed(by: disposeBag)

        loadMoreTrigger
            .flatMapLatest { [weak self] in
                self?.loadMoreTriggered() ?? .empty()
            }
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

    func refreshTriggered() -> Observable<Void> {
        listArticlesUseCase.listArticles(
            tag: nil,
            author: nil,
            favorited: nil,
            limit: limit,
            offset: 0
        )
        .do(
            onSuccess: { [weak self] in
                guard let self = self else { return }

                self.$didFinishRefresh.accept(())
                self.currentOffset = 0
                self.$articles.accept(self.$articles.value + $0)
            },
            onError: { [weak self] in
                guard let self = self else { return }

                self.$didFinishRefresh.accept(())
                self.$didFailToLoadArticle.accept($0)
            }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }

    func loadMoreTriggered() -> Observable<Void> {
        let offset = currentOffset + limit

        return listArticlesUseCase.listArticles(
            tag: nil,
            author: nil,
            favorited: nil,
            limit: limit,
            offset: offset
        )
        .do(
            onSuccess: { [weak self] in
                guard let self = self else { return }

                self.$didFinishLoadMore.accept(!$0.isEmpty)
                self.$articles.accept(self.$articles.value + $0)

                if !$0.isEmpty {
                    self.currentOffset = offset
                }
            },
            onError: { [weak self] in
                guard let self = self else { return }

                self.$didFinishLoadMore.accept(true)
                self.$didFailToLoadArticle.accept($0)
            }
        )
        .asObservable()
        .map { _ in () }
        .catchAndReturn(())
    }
}
