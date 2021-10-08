//
//  FeedsViewModelSpec.swift
//  NimbleMediumTests
//
//  Created by Mark G on 13/09/2021.
//

import Quick
import Nimble
import RxNimble
import RxSwift
import RxTest
import Resolver

@testable import NimbleMedium

final class FeedsViewModelSpec: QuickSpec {

    @LazyInjected var getListArticlesUseCase: GetListArticlesUseCaseProtocolMock

    override func spec() {
        var viewModel: FeedsViewModelProtocol!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!

        describe("a FeedsViewModel") {

            beforeEach {
                Resolver.registerMockServices()
                Resolver.mock.register { _, args -> ArticleRowViewModelProtocolMock in
                    let viewModel = ArticleRowViewModelProtocolMock()
                    let output = ArticleRowViewModelOutputMock()
                    viewModel.output = output

                    let article: Article = args.get()
                    let uiModel = ArticleRow.UIModel(
                        id: article.id,
                        articleTitle: article.title,
                        articleDescription: article.description,
                        articleUpdatedAt: article.updatedAt.format(with: .monthDayYear),
                        authorImage: try? article.author.image?.asURL(),
                        authorName: article.author.username
                    )
                    output.id = uiModel.id
                    output.uiModel = .just(uiModel)

                    return viewModel
                }
                .implements(ArticleRowViewModelProtocol.self)
                
                viewModel = FeedsViewModel()
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
            }

            describe("its toggleSideMenu() call") {

                beforeEach {
                    scheduler.scheduleAt(5) {
                        viewModel.input.toggleSideMenu()
                    }
                }

                it("returns output didToggleSideMenu with signal") {
                    expect(viewModel.output.didToggleSideMenu)
                        .events(scheduler: scheduler, disposeBag: disposeBag)
                        .notTo(beEmpty())
                }
            }

            describe("its refresh() call") {

                context("when ListArticlesUseCase return success") {
                    let inputArticles = APIArticlesResponse.dummy.articles

                    beforeEach {

                        self.getListArticlesUseCase
                            .executeTagAuthorFavoritedLimitOffsetReturnValue = .just(
                                inputArticles,
                                on: scheduler,
                                at: 10
                            )

                        scheduler.scheduleAt(5) {
                            viewModel.input.refresh()
                        }
                    }

                    it("returns output didFinishRefresh with signal") {
                        expect(viewModel.output.didFinishRefresh)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output feedRowViewModels with correct value") {
                        expect(
                            viewModel.output.articleRowViewModels
                                .map { $0.map { $0.output.id } }
                        )
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(0, []),
                                .next(10, inputArticles.map { $0.id })
                            ]
                    }
                }

                context("when ListArticlesUseCase return failure") {

                    beforeEach {
                        self.getListArticlesUseCase
                            .executeTagAuthorFavoritedLimitOffsetReturnValue = .error(
                                TestError.mock,
                                on: scheduler,
                                at: 10
                            )
                        scheduler.scheduleAt(5) {
                            viewModel.input.refresh()
                        }
                    }

                    it("returns output didFinishRefresh with signal") {
                        expect(viewModel.output.didFinishRefresh)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }

                    it("returns output didFailToLoadArticle with correct error") {
                        expect(viewModel.output.didFailToLoadArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }

            describe("its loadMore() call") {

                context("when ListArticlesUseCase return success") {

                    let inputArticles = APIArticlesResponse.dummy.articles

                    beforeEach {
                        self.getListArticlesUseCase.executeTagAuthorFavoritedLimitOffsetReturnValue = .just(
                            inputArticles,
                            on: scheduler,
                            at: 10
                        )
                        scheduler.scheduleAt(5) {
                            viewModel.input.loadMore()
                            self.getListArticlesUseCase.executeTagAuthorFavoritedLimitOffsetReturnValue = .just(
                                inputArticles,
                                on: scheduler,
                                at: 20
                            )
                        }
                        scheduler.scheduleAt(15) {
                            viewModel.input.loadMore()
                            self.getListArticlesUseCase.executeTagAuthorFavoritedLimitOffsetReturnValue = .just(
                                [],
                                on: scheduler,
                                at: 30
                            )
                        }
                        scheduler.scheduleAt(25) { viewModel.input.loadMore() }
                    }

                    it("returns output didFinishLoadMore with correct value") {
                        expect(viewModel.output.didFinishLoadMore)
                            .events(scheduler: scheduler, disposeBag: disposeBag) == [
                                .next(10, true),
                                .next(20, true),
                                .next(30, false)
                            ]
                    }

                    it("returns output feedRowViewModels with correct value") {
                        let ids = inputArticles
                            .map { $0.id }
                        let doubleIds = ids + ids
                        expect(
                            viewModel.output.articleRowViewModels
                                .map { $0.map { $0.output.id } }
                        )
                        .events(scheduler: scheduler, disposeBag: disposeBag) == [
                            .next(0, []),
                            .next(10, ids),
                            .next(20, doubleIds),
                            .next(30, doubleIds)
                        ]
                    }
                }

                context("when ListArticlesUseCase return failure") {

                    beforeEach {
                        self.getListArticlesUseCase.executeTagAuthorFavoritedLimitOffsetReturnValue = .error(
                            TestError.mock,
                            on: scheduler,
                            at: 10
                        )
                        scheduler.scheduleAt(5) { viewModel.input.loadMore() }
                    }

                    it("returns output didFailToLoadArticle with signal") {
                        expect(viewModel.output.didFailToLoadArticle)
                            .events(scheduler: scheduler, disposeBag: disposeBag)
                            .notTo(beEmpty())
                    }
                }
            }
        }
    }
}
